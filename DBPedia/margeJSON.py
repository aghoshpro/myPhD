import json

# Create a list of all the JSON files that you want to combine.
json_files = ["c:/Users/arkag/Downloads/MunichCity/688_5334.json", "c:/Users/arkag/Downloads/MunichCity/688_5336.json"]

# Create an empty list to store the Python objects.
python_objects = []

# Load each JSON file into a Python object.
for json_file in json_files:
    with open(json_file, "r") as f:
        python_objects.append(json.load(f))

# Dump all the Python objects into a single JSON file.
with open("combined.json", "w") as f:
    json.dump(python_objects, f, indent=4)