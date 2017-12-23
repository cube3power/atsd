SELECT datetime, entity, value
  FROM "mpstat.cpu_busy"
WHERE datetime > now - 1*minute
  LIMIT 3