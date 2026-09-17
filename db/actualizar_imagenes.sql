USE inmobiliaria_db;

-- 1. Borramos las imágenes viejas
DELETE FROM imagen_propiedad;

-- 2. Insertamos las nuevas rutas de las imágenes renombradas
INSERT INTO imagen_propiedad (id_propiedad, url_imagen, es_principal) VALUES 
(1, 'img/prop1_1.jpg', TRUE), (1, 'img/prop1_2.jpg', FALSE), (1, 'img/prop1_3.jpg', FALSE),
(2, 'img/prop2_1.jpg', TRUE), (2, 'img/prop2_2.jpg', FALSE), (2, 'img/prop2_3.jpg', FALSE),
(3, 'img/prop3_1.png', TRUE), (3, 'img/prop3_2.png', FALSE), (3, 'img/prop3_3.png', FALSE),
(4, 'img/prop4_1.png', TRUE), (4, 'img/prop4_2.png', FALSE), (4, 'img/prop4_3.png', FALSE),
(5, 'img/prop5_1.jpg', TRUE), (5, 'img/prop5_2.jpg', FALSE), (5, 'img/prop5_3.jpg', FALSE),
(6, 'img/prop6_1.jpg', TRUE), (6, 'img/prop6_2.jpg', FALSE), (6, 'img/prop6_3.jpg', FALSE),
(7, 'img/prop7_1.png', TRUE), (7, 'img/prop7_2.png', FALSE), (7, 'img/prop7_3.png', FALSE),
(8, 'img/prop8_1.png', TRUE), (8, 'img/prop8_2.png', FALSE), (8, 'img/prop8_3.png', FALSE),
(9, 'img/prop2_1.jpg', TRUE), (9, 'img/prop2_2.jpg', FALSE), (9, 'img/prop2_3.jpg', FALSE),
(10, 'img/prop5_1.jpg', TRUE), (10, 'img/prop5_2.jpg', FALSE), (10, 'img/prop5_3.jpg', FALSE);
