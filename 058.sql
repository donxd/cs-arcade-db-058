/*Please add ; after each select statement*/
CREATE PROCEDURE closestCells()
BEGIN
    SET @n = 0;

    SELECT 
        dataResult.id1,
        dataResult.id2
    FROM (
        SELECT 
            (@n := @n +1) as ind,
            dataGroups.id1,
            dataGroups.id2
            , dataGroups.distance
            -- MIN(dataGroups.distance)
        FROM (
            SELECT 
                -- MIN(dataPoints.ind),
                dataPoints.id1,
                dataPoints.id2,
                -- dataPoints.comb,
                dataPoints.distance
                -- MIN(dataPoints.distance)
            FROM (
                SELECT 
                -- (@n := @n +1) as ind,
                p1.id as id1 ,
                p2.id as id2 ,
                (p1.id * p2.id) as comb,
                -- CONCAT('LineString(', p1.x, ' ', p1.y, ' , ', p2.x, ' ', p2.y, ')') as line ,
                ST_Length(ST_GeomFromText(CONCAT('LineString(', p1.x, ' ', p1.y, ' , ', p2.x, ' ', p2.y, ')'))) as distance
                FROM positions p1 INNER JOIN positions p2 ON p2.id != p1.id
                ORDER BY comb, id1, id2
            ) dataPoints
            -- GROUP BY dataPoints.comb, dataPoints.distance
            -- GROUP BY dataPoints.id1
            -- ORDER BY dataPoints.id1, dataPoints.id2;
            ORDER BY dataPoints.id1, dataPoints.distance ASC -- ;
        ) dataGroups
        -- GROUP BY dataGroups.id1
        ORDER BY dataGroups.id1, dataGroups.distance ASC -- ;
    ) dataResult -- ;
    GROUP BY dataResult.id1
    ORDER BY dataResult.id1 ASC, dataResult.ind ASC;
END