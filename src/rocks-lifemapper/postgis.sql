
/* spacially enable postgis */
CREATE EXTENSION postgis;
CREATE EXTENSION postgis_topology;

/* set permissions on postgis tables for admin, reader, writer roles */
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE geometry_columns TO admin; 
GRANT SELECT ON TABLE geometry_columns TO reader,writer;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE geography_columns TO admin; 
GRANT SELECT ON TABLE geography_columns TO reader,writer;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE raster_columns TO admin; 
GRANT SELECT ON TABLE raster_columns TO reader,writer;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE raster_overviews TO admin; 
GRANT SELECT ON TABLE raster_overviews TO reader,writer;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE topology.topology TO admin; 
GRANT SELECT ON TABLE topology.topology TO reader,writer;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE topology.layer TO admin; 
GRANT SELECT ON TABLE topology.layer TO reader,writer;

GRANT SELECT ON TABLE spatial_ref_sys TO admin,reader,writer; 
GRANT USAGE ON SCHEMA topology TO admin,reader,writer;
GRANT SELECT ON TABLE topology.topology_id_seq TO reader; 
GRANT SELECT,UPDATE ON TABLE topology.topology_id_seq TO admin,writer;

