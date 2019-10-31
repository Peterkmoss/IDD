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

if __name__ == "__main__":
    pass
    #fd("Rentals", ["pid", "hid", "pn", "s", "hs", "hz", "hc"])
    #fd("Boats", ["bl", "bno", "z", "t", "bn", "ssn"])
    #fd("Projects", ["id", "pid", "sid", "sn", "pn", "mid", "mn"])
    #fd("Coffees", ["did", "hid", "cid", "dn", "ds", "cn", "cm"])
    #fd("Customers", ["cid", "cn", "cs", "cnr", "cz", "cc", "eid"])