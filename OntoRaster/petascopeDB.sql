CREATE OR REPLACE VIEW lookup_temp_x1 AS
	SELECT coverage.id, coverage.coverage_id, field.field_id, field.name AS field_name, wgs84_bounding_box.max_lat, wgs84_bounding_box.min_lat, wgs84_bounding_box.max_long, wgs84_bounding_box.min_long 	
	FROM public.coverage
	JOIN public.envelope ON coverage.envelope_id = envelope.envelope_id
	JOIN public.envelope_by_axis ON  envelope.envelope_by_axis_id = envelope_by_axis.envelope_by_axis_id
	JOIN public.wgs84_bounding_box ON envelope_by_axis.wgs84_bounding_box_id = wgs84_bounding_box.wgs84_bounding_box_id
	JOIN public.range_type ON coverage.range_type_id = range_type.range_type_id
    JOIN public.field ON field.data_record_id = range_type.data_record_id;



CREATE OR REPLACE VIEW lookup_peta_x1 AS	
	SELECT coverage.id, coverage.coverage_id, lookup_temp_x1.field_id, lookup_temp_x1.field_name, axis_extent.axis_label, axis_extent.lower_bound, axis_extent.grid_lower_bound, axis_extent.upper_bound, axis_extent.grid_upper_bound,lookup_temp_x1.max_lat, lookup_temp_x1.min_lat, lookup_temp_x1.max_long, lookup_temp_x1.min_long, geo_axis.resolution
	FROM public.coverage, public.envelope,  public.axis_extent, public.geo_axis, lookup_temp_x1
	WHERE coverage.envelope_id = envelope.envelope_id 
	AND envelope.envelope_by_axis_id = axis_extent.envelope_by_axis_id 
	AND axis_extent.upper_bound = geo_axis.upper_bound
	AND coverage.id = lookup_temp_x1.id;

