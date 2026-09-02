-- =====================================================
-- PROJETO INTEGRADOR
-- Banco de Dados: Monitoramento de Sarampo
-- =====================================================

DROP DATABASE IF EXISTS pi_sarampo;

CREATE DATABASE pi_sarampo;
USE pi_sarampo;

-- =====================================================
-- TABELA: MUNICIPIOS
-- =====================================================

CREATE TABLE municipios (
    id_municipio INT AUTO_INCREMENT PRIMARY KEY,
    nome_municipio VARCHAR(100) NOT NULL,
    estado CHAR(2) NOT NULL,
    regiao VARCHAR(20) NOT NULL,
    codigo_ibge VARCHAR(7) NOT NULL UNIQUE
);

-- =====================================================
-- TABELA: NOTIFICACOES
-- Armazena os casos de sarampo por município e ano
-- =====================================================

CREATE TABLE notificacoes (
    id_notificacao INT AUTO_INCREMENT PRIMARY KEY,
    id_municipio INT NOT NULL,
    ano_notificacao INT NOT NULL,
    numero_casos INT NOT NULL CHECK (numero_casos >= 0),

    CONSTRAINT fk_notificacoes_municipio
        FOREIGN KEY (id_municipio)
        REFERENCES municipios(id_municipio),

    CONSTRAINT uq_municipio_ano
        UNIQUE (id_municipio, ano_notificacao)
);

-- =====================================================
-- TABELA: IMIGRACAO
-- Armazena registros de imigração por município
-- =====================================================

CREATE TABLE imigracao (
    id_imigracao INT AUTO_INCREMENT PRIMARY KEY,
    id_municipio INT NOT NULL,
    ano_imigracao INT NOT NULL,
    pais_origem VARCHAR(50) NOT NULL,
    quantidade_imigrantes INT NOT NULL CHECK (quantidade_imigrantes > 0),

    CONSTRAINT fk_imigracao_municipio
        FOREIGN KEY (id_municipio)
        REFERENCES municipios(id_municipio),

    CONSTRAINT uq_municipio_ano_pais
        UNIQUE (id_municipio, ano_imigracao, pais_origem)
);

-- =====================================================
-- TABELA: COBERTURA_VACINAL
-- Armazena cobertura das doses da vacina contra sarampo
-- =====================================================

CREATE TABLE cobertura_vacinal (
    id_cobertura INT AUTO_INCREMENT PRIMARY KEY,
    id_municipio INT NOT NULL,
    ano_cobertura INT NOT NULL,

    cobertura_d1 DECIMAL(5,2) NOT NULL
        CHECK (cobertura_d1 BETWEEN 0.00 AND 100.00),

    cobertura_d2 DECIMAL(5,2) NOT NULL
        CHECK (cobertura_d2 BETWEEN 0.00 AND 100.00),

    atingiu_meta BOOLEAN NOT NULL,

    CONSTRAINT fk_cobertura_municipio
        FOREIGN KEY (id_municipio)
        REFERENCES municipios(id_municipio),

    CONSTRAINT uq_municipio_ano_cobertura
        UNIQUE (id_municipio, ano_cobertura)
);
