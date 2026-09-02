USE pi_sarampo;

-- =====================================================
-- Foram inseridos dados referentes a municípios, 
cobertura vacinal, notificações e imigração.
-- =====================================================

INSERT INTO municipios
(nome_municipio, estado, regiao, codigo_ibge)
VALUES
('São Paulo', 'SP', 'Sudeste', '3550308'),
('Boa Vista', 'RR', 'Norte', '1400100'),
('Santos', 'SP', 'Sudeste', '3548500');

-- =====================================================
-- COBERTURA VACINAL - 2026
-- =====================================================

INSERT INTO cobertura_vacinal
(id_municipio, ano_cobertura, cobertura_d1, cobertura_d2, atingiu_meta)
VALUES
(1, 2026, 85.00, 68.50, FALSE),
(2, 2026, 70.00, 52.00, FALSE),
(3, 2026, 98.00, 95.00, TRUE);

-- =====================================================
-- NOTIFICAÇÕES DE SARAMPO - 2026
-- =====================================================

INSERT INTO notificacoes
(id_municipio, ano_notificacao, numero_casos)
VALUES
(1, 2026, 450),
(2, 2026, 600),
(3, 2026, 12);

-- =====================================================
-- IMIGRAÇÃO - 2026
-- =====================================================

INSERT INTO imigracao
(id_municipio, ano_imigracao, pais_origem, quantidade_imigrantes)
VALUES
(1, 2026, 'Bolívia', 300),
(2, 2026, 'Venezuela', 800),
(2, 2026, 'Guiana', 300);

-- Observação:
-- Santos não possui registro de imigração
-- para demonstrar consultas com LEFT JOIN.
