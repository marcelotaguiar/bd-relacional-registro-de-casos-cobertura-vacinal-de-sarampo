USE pi_sarampo;

CREATE VIEW vw_monitoramento_sarampo AS
SELECT
    m.nome_municipio,
    m.estado,
    n.ano_notificacao,
    n.numero_casos,
    c.cobertura_d1,
    c.cobertura_d2,
    c.atingiu_meta,
    COALESCE(SUM(i.quantidade_imigrantes), 0) AS total_imigrantes
FROM municipios m
LEFT JOIN notificacoes n
    ON m.id_municipio = n.id_municipio
LEFT JOIN cobertura_vacinal c
    ON m.id_municipio = c.id_municipio
    AND n.ano_notificacao = c.ano_cobertura
LEFT JOIN imigracao i
    ON m.id_municipio = i.id_municipio
    AND n.ano_notificacao = i.ano_imigracao
GROUP BY
    m.nome_municipio,
    m.estado,
    n.ano_notificacao,
    n.numero_casos,
    c.cobertura_d1,
    c.cobertura_d2,
    c.atingiu_meta;

-- Teste da View
SELECT * FROM vw_monitoramento_sarampo;
