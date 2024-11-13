# Install  pip install -q sparqlwrapper  

from SPARQLWrapper import SPARQLWrapper, JSON, XML, RDF
import pandas as pd



####################
# SPARQL Endpoints #
####################

sparql = SPARQLWrapper("http://dbpedia.org/sparql")  # to DBPedia
sparql.setReturnFormat(JSON)  # Set the output format i.e., JSON, XML, RDF

sparql2 = SPARQLWrapper("http://slod.fiz-karlsruhe.de/sparql")  #  Linked Stage Graph contains black and white photographs and metadata about the Stuttgart State Theatre from the 1890s to the 1940s
sparql2.setReturnFormat(JSON) 

linkedgeosparql = SPARQLWrapper("http://linkedgeodata.org/sparql")
linkedgeosparql.setReturnFormat(JSON) 

wikidatasparql = SPARQLWrapper("https://query.wikidata.org/sparql")
wikidatasparql.setReturnFormat(JSON) 

rasSparql = SPARQLWrapper("http://localhost:8082/sparql")
rasSparql.setReturnFormat(JSON) 

################
# SPARQL Query #
################

### DBPedia Query
Q1 = """
    PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    PREFIX dbp: <http://dbpedia.org/property/>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX dbc: <http://dbpedia.org/resource/Category:>
    PREFIX dct: <http://purl.org/dc/terms/>

    Select distinct ?date ?author ?authorName ?thumbnail ?description
    WHERE {
    ?author rdf:type dbo:Writer ;
                dct:subject dbc:Nobel_laureates_in_Literature ;
            rdfs:label ?authorName ;
            dbo:wikiPageWikiLink ?link ;
            rdfs:comment ?description
    FILTER ((lang(?authorName)="en")&&(lang(?description)="en")) .

    ?link dct:subject dbc:Nobel_Prize_in_Literature ;
            dbp:holderLabel ?date .
    OPTIONAL { ?author dbo:thumbnail ?thumbnail . }
    }

    ORDER BY ?date

    """

Q2 = """
    PREFIX dbo: <http://dbpedia.org/ontology/>
    PREFIX dbp: <http://dbpedia.org/property/>
    PREFIX dbr: <http://dbpedia.org/resource/>

    SELECT DISTINCT ?name ?occupation

    WHERE {

    {?person rdf:type dbo:Poet} UNION {?person dbo:occupation dbr:Poet} UNION {?person dbp:occupation ?occupation}  .
    ?person rdfs:label ?name .
    FILTER ((LANG(?name)="en")&&(LANG(?occupation) = "en")) .

    #FILTER (LANG(?occupation) = "en").
    FILTER(regex(?occupation, "[pP]oet" ))

    }
"""

### Wikidata Query
Q3 = """
    PREFIX dcterms: <http://purl.org/dc/terms/>
    PREFIX schema: <http://schema.org/>
    PREFIX slod: <http://slod.fiz-karlsruhe.de/>
    PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
    PREFIX wdt: <http://www.wikidata.org/prop/direct/>


    SELECT DISTINCT ?resource ?resourcelabel ?contributor ?contributorlabel ?birthyear ?birthplace
        WHERE {
            ?resource schema:contributor ?contributor .
            ?resource rdfs:label ?resourcelabel .

            SERVICE <https://query.wikidata.org/sparql> {
                ?contributor wdt:P569 ?birthdate .
                            ?contributor wdt:P19 ?birthplace .
        ?contributor rdfs:label ?contributorlabel FILTER (LANG(?contributorlabel) = "en") .
                    }
        BIND (YEAR(?birthdate) AS ?birthyear)
            }
    Group BY ?birthyear
    ORDER BY DESC(?birthyear)
 """


Q4 = """
    SELECT ?eyeColor ?eyeColorLabel ?rgb (COUNT(?human) AS ?count)
        WHERE
            {
                ?human wdt:P31 wd:Q5.
                ?human wdt:P1340 ?eyeColor.
                OPTIONAL { ?eyeColor wdt:P465 ?rgb. }
                SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],mul,en". }
            }
    GROUP BY ?eyeColor ?eyeColorLabel ?rgb
    ORDER BY DESC(?count)
"""

### OntoRaster Query 
### (docker compose up ONtoRaster and then run the following query)

Q5 = """
PREFIX :	<https://github.com/aghoshpro/OntoRaster/>
PREFIX rdfs:	<http://www.w3.org/2000/01/rdf-schema#>
PREFIX geo:	<http://www.opengis.net/ont/geosparql#>
PREFIX rasdb:	<https://github.com/aghoshpro/RasterDataCube/>

SELECT ?answer ?regionName ?regionWkt {
?region a :Region .
?region rdfs:label ?regionName .
?region geo:asWKT ?regionWkt .
?gridCoverage a :Raster .
?gridCoverage rasdb:rasterName ?rasterName .
FILTER (?regionName = 'Göteborg') # also try with Linköping, Uppsala, Göteborg, Stockholm etc.
FILTER (CONTAINS(?rasterName, 'Sweden'))
BIND ('2022-08-24T00:00:00+00:00'^^xsd:dateTime AS ?timeStamp)
BIND (rasdb:rasSpatialMaximum(?timeStamp, ?regionWkt, ?rasterName) AS ?answer)
} 
"""

###########################
# SPARQL Query execution  #
###########################

sparql.setQuery(Q2)
sparql2.setQuery(Q3)
wikidatasparql.setQuery(Q4)
rasSparql.setQuery(Q5) 

answers = sparql.query().convert()   # execute SPARQL query and write result to "results"
answers2 = sparql2.query().convert()   # execute SPARQL query and write result to "results"
answers3 = wikidatasparql.query().convert()   # execute SPARQL query and write result to "results"
answers4 = rasSparql.query().convert()   # execute SPARQL query and write result to "results"

##########
# Output #
##########

# print(answers4) # OUTPUT Unstructured JSON

df = pd.json_normalize(answers4['results']['bindings'])  

# print(df) # OUTPUT Structured JSON

# print(df[['date.value', 'author.value', 'authorName.value', 'thumbnail.value', 'description.value ']])
# print(df[['resource.value', 'resourcelabel.value', 'contributorlabel.value', 'birthyear.value', 'birthplace.value']])
# print(df[['eyeColor.value', 'eyeColorLabel.value', 'rgb.value', 'count.value']])

print(df[['regionName.value', 'answer.value' ,'regionWkt.value']])

