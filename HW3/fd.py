def fd(relation, columns):
    for c1 in columns:
        for c2 in columns:
            if c1 != c2:
                print(f"SELECT '{c1} ---> {c2}' AS FD,")
                print("CASE WHEN COUNT(*)=0 THEN 'MAY HOLD'")
                print("ELSE 'does not hold' END AS VALIDITY")
                print("FROM (")
                print(f"SELECT {c1}")
                print(f"  FROM {relation}")
                print(f"  GROUP BY {c1}")
                print(f"  HAVING COUNT(DISTINCT {c2}) > 1")
                print(") X;")
                print()

fd("Projects", ["id", "pid", "sid", "sn", "pn", "mid", "mn"])
