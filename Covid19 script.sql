USE Covid19Data
GO


-- Total de Casos e Mortes por Continente

SELECT 
    continent,
    SUM(total_cases) AS total_cases,
    SUM(CAST(total_deaths AS FLOAT)) AS total_deaths

FROM CovidDeaths
    
WHERE 
    continent IS NOT NULL
GROUP BY 
    continent
ORDER BY 
    total_cases DESC;


	-- Evolução dos Casos ao Longo do Tempo (Média de Novos Casos) 

	SELECT 
    date,
    SUM(CAST(new_cases AS FLOAT)) AS total_new_cases,
    AVG(CAST(new_cases AS FLOAT)) AS average_new_cases
FROM 
    CovidDeaths
WHERE 
    ISNUMERIC(new_cases) = 1
GROUP BY 
    date
ORDER BY 
    date;



	-- Pico de Casos e Mortes por País

	SELECT 
    c.location,
    c.date,
    c.new_cases,
    c.new_deaths
FROM 
    CovidDeaths c
JOIN (
    SELECT 
        location, 
        MAX(new_cases) AS max_new_cases
    FROM 
        CovidDeaths
    WHERE 
        continent IS NOT NULL
    GROUP BY 
        location
) AS sub
ON 
    c.location = sub.location AND c.new_cases = sub.max_new_cases
ORDER BY 
    c.new_cases DESC;


	-- Taxa de Mortalidade por Milhão de Habitantes

	SELECT 
    location,
    MAX(total_deaths_per_million) AS death_rate_per_million
FROM 
    CovidDeaths
WHERE 
    total_deaths_per_million IS NOT NULL
GROUP BY 
    location
ORDER BY 
    death_rate_per_million DESC;

   
   -- Relação entre PIB e Taxa de Mortalidade

   SELECT 
    location,
    gdp_per_capita,
    MAX(total_deaths_per_million) AS death_rate_per_million
FROM 
    CovidDeaths
WHERE 
    gdp_per_capita IS NOT NULL
GROUP BY 
    location, gdp_per_capita
ORDER BY 
    gdp_per_capita DESC;


	-- Efeito das Restrições (Stringency Index) na Taxa de Novos Casos

	SELECT 
    date,
    location,
    stringency_index,
    new_cases
FROM 
    CovidDeaths
WHERE 
    stringency_index IS NOT NULL
ORDER BY 
    stringency_index DESC, new_cases DESC;


	SELECT 
    location,
    MAX(total_deaths_per_million) AS max_deaths_per_million
FROM 
    CovidDeaths
WHERE 
    continent IS NOT NULL
GROUP BY 
    location
ORDER BY 
    max_deaths_per_million DESC;

	
	-- Países com a Maior Taxa de Mortalidade por Tamanho da População

	SELECT TOP 100
    location,
    MAX((total_deaths / population) * 100) AS mortality_rate_percent
FROM 
    CovidDeaths
WHERE 
    continent IS NOT NULL 
    AND total_deaths IS NOT NULL 
    AND population > 0
GROUP BY 
    location
ORDER BY 
    mortality_rate_percent DESC;
