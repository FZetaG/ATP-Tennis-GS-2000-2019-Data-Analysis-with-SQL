--Cantidad de partidos ganados por jugador
SELECT name, COUNT(*) AS 'Partidos Ganados'
FROM Match AS m
INNER JOIN Stats AS s
ON m.match_id=s.match_id
INNER JOIN Player AS p
ON s.player_id=p.player_id
WHERE s.winner= 'True'
GROUP BY name
ORDER BY 'Partidos Ganados' DESC;

--Promedio de aces por partido
SELECT p.name, avg(s.aces) AS 'Promedio Aces'
FROM Match AS m
INNER JOIN Stats AS s
ON m.match_id=s.match_id
INNER JOIN Player AS p
ON s.player_id=p.player_id
GROUP BY p.name
ORDER BY 'Promedio Aces' DESC;

--Cantidad de aces y cantidad de partidos ganados y perdidos por jugador
SELECT name, sum(aces) AS 'Aces Totales',
SUM(CASE WHEN winner = 'True' THEN 1
       ELSE 0  
END) AS Partidos_Ganados,
SUM(CASE WHEN winner = 'False' THEN 1
       ELSE 0 
END) AS Partidos_Perdidos
FROM Match AS m
INNER JOIN Stats AS s
ON m.match_id=s.match_id
INNER JOIN Player AS p
ON s.player_id=p.player_id
GROUP BY name
ORDER BY 'Aces Totales' DESC;

--CANTIDAD DE GRAND SLAMS GANADOS POR JUGADOR
WITH partidos_finales AS(
	SELECT tournament, year, match_id
	FROM Match
	WHERE round= 'The Final'
	)
SELECT p.name, count(*) AS 'Titulos Ganados de Grand Slam'
FROM partidos_finales AS f
INNER JOIN Stats AS s
ON f.match_id=s.match_id
INNER JOIN Player AS p
ON s.player_id=p.player_id
WHERE winner= 'True'
GROUP BY p.name
ORDER BY 'Titulos Ganados de Grand Slam' DESC;


--Estadisticas del Big Four
WITH Estadisticas AS (
  SELECT player_id,
         ROUND(AVG(first_serve_per),2) AS avg_first_serve_per,
         ROUND(AVG(bp_saved / NULLIF(bp_faced, 0)),2) AS bp_salvados_pct,
         ROUND(AVG(return_pts / NULLIF(total_pts, 0)),2) AS puntos_retorno_pct,
         ROUND(AVG(service_pts / NULLIF(total_pts, 0)),2) AS puntos_servicio_pct,
		 ROUND(AVG(first_serve_in),2) AS avg_first_serve_in,
         ROUND(AVG(aces),2) AS avg_aces
  FROM Stats
  GROUP BY player_id
)
SELECT p.name,
       e.avg_first_serve_per,
       e.bp_salvados_pct,
       e.puntos_servicio_pct,
	   e.puntos_retorno_pct,
	   e.avg_first_serve_in,
       e.avg_aces
FROM Estadisticas AS e
INNER JOIN Player AS p ON e.player_id = p.player_id
WHERE p.name = 'Roger Federer' OR p.name = 'Rafael Nadal' OR p.name = 'Novak Djokovic' OR p.name='Andy Murray'
ORDER BY e.avg_first_serve_per DESC, e.bp_salvados_pct DESC;