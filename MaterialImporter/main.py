import csv

stats = [
    "power",
    "potency",
    "dexterity",
    "precision",
    "ferocity",
    "mastery",
    "expertise",
    "armor",
    "occult_aversion",
    "vitality",
    "toughess",
    "penetration",
    "magic_penetration"
]

types = {
    "Gem": 0,
    "Metal": 1,
    "Wood": 2,
    "Fabric": 3,
    "Leather": 4
}

rarities = {
    "Basic": 0,
    "Common": 1,
    "Uncommon": 2,
    "Rare": 3,
    "Epic": 4,
    "Legendary": 5
}

icon_textures = {
    "Metal": 0,
    "Wood": 1,
    "Gem": 2,
    "Leather": 3
}


def file_from_line(line):
    file_name_mat = "../Materials/" + str(rarities[line["rarity"]]) + "_" + line["rarity"] + "/" + line["slottable_name"].replace(" ", "") + ".tres"
    with open(file_name_mat, 'w') as file:
        file.write(
            "[gd_resource type=\"Resource\" load_steps=2 format=2]\n"
            "\n"
            "[ext_resource path=\"res://Materials/MaterialResource.gd\" type=\"Script\" id=1]\n"
            "\n"
            "[resource]\n"
            "script = ExtResource( 1 )\n"
        )
        file.write("icon_texture = " + str(icon_textures[line["type"]]) + "\n")
        file.write("icon_color = Color( " + str(int(line["r"]) / 256) + ", " + str(int(line["g"]) / 256) + ", " + str(int(line["b"]) / 256) + ", 1 )\n")
        file.write("slottable_name = \"" + line["slottable_name"] + "\"\n")
        file.write("prefix = \"" + line["slottable_name"] + "\"\n")
        file.write("special_weapon = \"" + line["special_weapon"] + "\"\n")
        file.write("special_armor = \"" + line["special_armor"] + "\"\n")
        file.write("special_accessory = \"" + line["special_accessory"] + "\"\n")
        file.write("type = " + str(types[line["type"]]) + "\n")
        file.write("rarity = " + str(rarities[line["rarity"]]) + "\n")
        file.write("stats = {\n")
        for stat in stats:
            file.write("\"" + stat + "\": " + str(line[stat]) + ",\n")
        file.write("}\n")

    file_name_loot = "../Lootable/Materials/" + line["slottable_name"].replace(" ", "") + "Lootable.tres"
    with open(file_name_loot, 'w') as file:
        file.write(
            "[gd_resource type=\"Resource\" load_steps=3 format=2]\n"
            "\n"
            "[ext_resource path=\"res://Lootable/_MaterialLootable.gd\" type=\"Script\" id=1]\n"
            "[ext_resource path=\"res://" + file_name_mat.replace("../", "") + "\" type=\"Resource\" id=2]\n"
            "\n"
            "[resource]\n"
            "script = ExtResource( 1 )\n"
            "chance = 1.0\n"
            "material = ExtResource( 2 )\n"
            "base_min_quantity = 1\n"
            "base_max_quantity = 1\n"
        )


with open('Materials.csv', 'r') as file:
    reader = csv.DictReader(file)

    for line in reader:
        if line["armor"] != "" and line["special_weapon"] == "" and line["special_armor"] == "" and line["special_accessory"] == "":
            file_from_line(line)
