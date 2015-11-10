SELECT c.column_name AS column_name, c.data_type,
c.is_nullable AS nullable
FROM information_schema.columns c
LEFT JOIN information_schema.element_types e ON
c.table_catalog = e.object_catalog AND
c.table_schema = e.object_schema AND
c.table_name = e.object_name AND
''TABLE'' = e.object_type
--WHERE UPPER(c.table_name) = upper( 'NOMBRE_TABLA' )
ORDER BY c.column_name
