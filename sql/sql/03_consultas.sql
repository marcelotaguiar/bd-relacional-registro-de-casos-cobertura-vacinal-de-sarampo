USE pi_sarampo;

-- =====================================================
-- CONSULTA 1
-- Dados completos por município
-- =====================================================

SELECT
    m.nome_municipio,
    m.estado,
    n.numero_casos,
    c.cobertura_d1,
    c.cobertura_d2,
    c.atingiu_meta
FROM municipios m
INNER JOIN notificacoes n
    ON m.id_municipio = n.id_municipio
INNER JOIN cobertura_vacinal c
    ON m.id_municipio = c.id_municipio
ORDER BY n.numero_casos DESC;

-- =====================================================
-- CONSULTA 2
-- Total de imigrantes por município
-- =====================================================

SELECT
    m.nome_municipio,
    COALESCE(SUM(i.quantidade_imigrantes), 0) AS total_imigrantes
FROM municipios m
LEFT JOIN imigracao i
    ON m.id_municipio = i.id_municipio
GROUP BY m.nome_municipio;

-- =====================================================
-- CONSULTA 3
-- Municípios que não atingiram a meta vacinal
-- =====================================================

SELECT
    m.nome_municipio,
    c.cobertura_d2,
    n.numero_casos
FROM municipios m
INNER JOIN cobertura_vacinal c
    ON m.id_municipio = c.id_municipio
INNER JOIN notificacoes n
    ON m.id_municipio = n.id_municipio
WHERE c.atingiu_meta = FALSE
ORDER BY n.numero_casos DESC;

-- =====================================================
-- CONSULTA 4
-- Relação entre imigração e casos registrados
-- =====================================================

SELECT
    m.nome_municipio,
    n.numero_casos,
    COALESCE(SUM(i.quantidade_imigrantes), 0) AS total_imigrantes
FROM municipios m
LEFT JOIN notificacoes n
    ON m.id_municipio = n.id_municipio
LEFT JOIN imigracao i
    ON m.id_municipio = i.id_municipio
GROUP BY
    m.nome_municipio,
    n.numero_casos
ORDER BY total_imigrantes DESC;
