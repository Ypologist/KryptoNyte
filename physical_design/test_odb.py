import odb

try:
    db = odb.dbDatabase.create()
    chip = odb.dbChip_create(db)
    block = odb.dbBlock_create(chip, "blk")

    region = odb.dbRegion_create(block, "fetch_region")
    odb.dbBox_create(region, 0, 11250000, 14900000, 14900000)
    region.setRegionType("INCLUSIVE")

    group = odb.dbGroup_create(block, "fetch_group")
    group.setType("PHYSICAL_CLUSTER")
    region.addGroup(group)

    print("SUCCESS")
except Exception as e:
    import traceback
    traceback.print_exc()
