-- Find names of top 3 sites for Velociraptor Bones for 2014

-- SELECT
-- finds.site_id as site_id
-- ,COUNT(bones.name) as bone_count
-- FROM finds
-- JOIN dino_bones as bones
-- ON bones.id = finds.bone_id
-- WHERE bones.name = 'Velociraptor'
-- GROUP BY 1
-- ORDER BY 2 DESC
-- LIMIT 3;

-- Find names of top 3 sites each year for Vlociraptor Bones


with tempTable as
(
  SELECT
  year
  ,site_name
  ,bone_count
  ,ROW_NUMBER() OVER (PARTITION BY year ORDER BY bone_count DESC) as site_rank
  FROM (
    SELECT
    date_part('year', finds.date_found) as year
    ,sites.name as site_name
    ,COUNT(bones.name) as bone_count
    FROM finds
    JOIN dino_bones as bones
    ON bones.id = finds.bone_id
    JOIN sites
    ON sites.id = finds.site_id
    GROUP BY 1, 2
    ORDER BY 1, 3 DESC
  ) as temp
  GROUP BY 1, 2, 3
)

SELECT *
FROM tempTable
WHERE site_rank < 4;
