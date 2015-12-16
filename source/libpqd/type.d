module libpqd.type;

import libpqd.pq;

/// Type
struct PGType {
    Oid oid;
    int len;
}

/// Convert into PGType
alias PGTypeOf(T : bool) = Type.PGbool;
alias PGTypeOf(T : ubyte[]) = Type.PGbytea;
alias PGTypeOf(T : char) = Type.PGchar;
alias PGTypeOf(T : char[64]) = Type.PGname;
alias PGTypeOf(T : long) = Type.PGint8;
alias PGTypeOf(T : short) = Type.PGint2;
alias PGTypeOf(T : short[]) = Type.PGint2vector;
alias PGTypeOf(T : int) = Type.PGint4;
alias PGTypeOf(T : char[]) = Type.PGtext;
alias PGTypeOf(T : string) = Type.PGtext;
alias PGTypeOf(T : float) = Type.PGfloat4;
alias PGTypeOf(T : double) = Type.PGfloat8;

PGType PGTypeOf(Oid oid) {
    import std.traits;
    
    foreach (type; EnumMembers!Type) {
        if (type.oid == oid) {
            return type;
        }
    }
    assert(0);
}

/// Types
///
/// Generated with following SQL:
///     SELECT 'PG' || typname || ' = PGType(' || oid || ', ' || typlen || '),' FROM pg_type;
enum Type {
    PGbool = PGType(16, 1),
    PGbytea = PGType(17, -1),
    PGchar = PGType(18, 1),
    PGname = PGType(19, 64),
    PGint8 = PGType(20, 8),
    PGint2 = PGType(21, 2),
    PGint2vector = PGType(22, -1),
    PGint4 = PGType(23, 4),
    PGregproc = PGType(24, 4),
    PGtext = PGType(25, -1),
    PGoid = PGType(26, 4),
    PGtid = PGType(27, 6),
    PGxid = PGType(28, 4),
    PGcid = PGType(29, 4),
    PGoidvector = PGType(30, -1),
    PGpg_type = PGType(71, -1),
    PGpg_attribute = PGType(75, -1),
    PGpg_proc = PGType(81, -1),
    PGpg_class = PGType(83, -1),
    PGjson = PGType(114, -1),
    PGxml = PGType(142, -1),
    PG_xml = PGType(143, -1),
    PG_json = PGType(199, -1),
    PGpg_node_tree = PGType(194, -1),
    PGsmgr = PGType(210, 2),
    PGpoint = PGType(600, 16),
    PGlseg = PGType(601, 32),
    PGpath = PGType(602, -1),
    PGbox = PGType(603, 32),
    PGpolygon = PGType(604, -1),
    PGline = PGType(628, 24),
    PG_line = PGType(629, -1),
    PGfloat4 = PGType(700, 4),
    PGfloat8 = PGType(701, 8),
    PGabstime = PGType(702, 4),
    PGreltime = PGType(703, 4),
    PGtinterval = PGType(704, 12),
    PGunknown = PGType(705, -2),
    PGcircle = PGType(718, 24),
    PG_circle = PGType(719, -1),
    PGmoney = PGType(790, 8),
    PG_money = PGType(791, -1),
    PGmacaddr = PGType(829, 6),
    PGinet = PGType(869, -1),
    PGcidr = PGType(650, -1),
    PG_bool = PGType(1000, -1),
    PG_bytea = PGType(1001, -1),
    PG_char = PGType(1002, -1),
    PG_name = PGType(1003, -1),
    PG_int2 = PGType(1005, -1),
    PG_int2vector = PGType(1006, -1),
    PG_int4 = PGType(1007, -1),
    PG_regproc = PGType(1008, -1),
    PG_text = PGType(1009, -1),
    PG_oid = PGType(1028, -1),
    PG_tid = PGType(1010, -1),
    PG_xid = PGType(1011, -1),
    PG_cid = PGType(1012, -1),
    PG_oidvector = PGType(1013, -1),
    PG_bpchar = PGType(1014, -1),
    PG_varchar = PGType(1015, -1),
    PG_int8 = PGType(1016, -1),
    PG_point = PGType(1017, -1),
    PG_lseg = PGType(1018, -1),
    PG_path = PGType(1019, -1),
    PG_box = PGType(1020, -1),
    PG_float4 = PGType(1021, -1),
    PG_float8 = PGType(1022, -1),
    PG_abstime = PGType(1023, -1),
    PG_reltime = PGType(1024, -1),
    PG_tinterval = PGType(1025, -1),
    PG_polygon = PGType(1027, -1),
    PGaclitem = PGType(1033, 12),
    PG_aclitem = PGType(1034, -1),
    PG_macaddr = PGType(1040, -1),
    PG_inet = PGType(1041, -1),
    PG_cidr = PGType(651, -1),
    PG_cstring = PGType(1263, -1),
    PGbpchar = PGType(1042, -1),
    PGvarchar = PGType(1043, -1),
    PGdate = PGType(1082, 4),
    PGtime = PGType(1083, 8),
    PGtimestamp = PGType(1114, 8),
    PG_timestamp = PGType(1115, -1),
    PG_date = PGType(1182, -1),
    PG_time = PGType(1183, -1),
    PGtimestamptz = PGType(1184, 8),
    PG_timestamptz = PGType(1185, -1),
    PGinterval = PGType(1186, 16),
    PG_interval = PGType(1187, -1),
    PG_numeric = PGType(1231, -1),
    PGtimetz = PGType(1266, 12),
    PG_timetz = PGType(1270, -1),
    PGbit = PGType(1560, -1),
    PG_bit = PGType(1561, -1),
    PGvarbit = PGType(1562, -1),
    PG_varbit = PGType(1563, -1),
    PGnumeric = PGType(1700, -1),
    PGrefcursor = PGType(1790, -1),
    PG_refcursor = PGType(2201, -1),
    PGregprocedure = PGType(2202, 4),
    PGregoper = PGType(2203, 4),
    PGregoperator = PGType(2204, 4),
    PGregclass = PGType(2205, 4),
    PGregtype = PGType(2206, 4),
    PG_regprocedure = PGType(2207, -1),
    PG_regoper = PGType(2208, -1),
    PG_regoperator = PGType(2209, -1),
    PG_regclass = PGType(2210, -1),
    PG_regtype = PGType(2211, -1),
    PGuuid = PGType(2950, 16),
    PG_uuid = PGType(2951, -1),
    PGpg_lsn = PGType(3220, 8),
    PG_pg_lsn = PGType(3221, -1),
    PGtsvector = PGType(3614, -1),
    PGgtsvector = PGType(3642, -1),
    PGtsquery = PGType(3615, -1),
    PGregconfig = PGType(3734, 4),
    PGregdictionary = PGType(3769, 4),
    PG_tsvector = PGType(3643, -1),
    PG_gtsvector = PGType(3644, -1),
    PG_tsquery = PGType(3645, -1),
    PG_regconfig = PGType(3735, -1),
    PG_regdictionary = PGType(3770, -1),
    PGjsonb = PGType(3802, -1),
    PG_jsonb = PGType(3807, -1),
    PGtxid_snapshot = PGType(2970, -1),
    PG_txid_snapshot = PGType(2949, -1),
    PGint4range = PGType(3904, -1),
    PG_int4range = PGType(3905, -1),
    PGnumrange = PGType(3906, -1),
    PG_numrange = PGType(3907, -1),
    PGtsrange = PGType(3908, -1),
    PG_tsrange = PGType(3909, -1),
    PGtstzrange = PGType(3910, -1),
    PG_tstzrange = PGType(3911, -1),
    PGdaterange = PGType(3912, -1),
    PG_daterange = PGType(3913, -1),
    PGint8range = PGType(3926, -1),
    PG_int8range = PGType(3927, -1),
    PGrecord = PGType(2249, -1),
    PG_record = PGType(2287, -1),
    PGcstring = PGType(2275, -2),
    PGany = PGType(2276, 4),
    PGanyarray = PGType(2277, -1),
    PGvoid = PGType(2278, 4),
    PGtrigger = PGType(2279, 4),
    PGevent_trigger = PGType(3838, 4),
    PGlanguage_handler = PGType(2280, 4),
    PGinternal = PGType(2281, 8),
    PGopaque = PGType(2282, 4),
    PGanyelement = PGType(2283, 4),
    PGanynonarray = PGType(2776, 4),
    PGanyenum = PGType(3500, 4),
    PGfdw_handler = PGType(3115, 4),
    PGanyrange = PGType(3831, -1),
    PGpg_attrdef = PGType(10000, -1),
    PGpg_constraint = PGType(10001, -1),
    PGpg_inherits = PGType(10002, -1),
    PGpg_index = PGType(10003, -1),
    PGpg_operator = PGType(10004, -1),
    PGpg_opfamily = PGType(10005, -1),
    PGpg_opclass = PGType(10006, -1),
    PGpg_am = PGType(10125, -1),
    PGpg_amop = PGType(10126, -1),
    PGpg_amproc = PGType(10563, -1),
    PGpg_language = PGType(10908, -1),
    PGpg_largeobject_metadata = PGType(10909, -1),
    PGpg_largeobject = PGType(10910, -1),
    PGpg_aggregate = PGType(10911, -1),
    PGpg_statistic = PGType(10912, -1),
    PGpg_rewrite = PGType(10913, -1),
    PGpg_trigger = PGType(10914, -1),
    PGpg_event_trigger = PGType(10915, -1),
    PGpg_description = PGType(10916, -1),
    PGpg_cast = PGType(10917, -1),
    PGpg_enum = PGType(11116, -1),
    PGpg_namespace = PGType(11117, -1),
    PGpg_conversion = PGType(11118, -1),
    PGpg_depend = PGType(11119, -1),
    PGpg_database = PGType(1248, -1),
    PGpg_db_role_setting = PGType(11120, -1),
    PGpg_tablespace = PGType(11121, -1),
    PGpg_pltemplate = PGType(11122, -1),
    PGpg_authid = PGType(2842, -1),
    PGpg_auth_members = PGType(2843, -1),
    PGpg_shdepend = PGType(11123, -1),
    PGpg_shdescription = PGType(11124, -1),
    PGpg_ts_config = PGType(11125, -1),
    PGpg_ts_config_map = PGType(11126, -1),
    PGpg_ts_dict = PGType(11127, -1),
    PGpg_ts_parser = PGType(11128, -1),
    PGpg_ts_template = PGType(11129, -1),
    PGpg_extension = PGType(11130, -1),
    PGpg_foreign_data_wrapper = PGType(11131, -1),
    PGpg_foreign_server = PGType(11132, -1),
    PGpg_user_mapping = PGType(11133, -1),
    PGpg_foreign_table = PGType(11134, -1),
    PGpg_default_acl = PGType(11135, -1),
    PGpg_seclabel = PGType(11136, -1),
    PGpg_shseclabel = PGType(11137, -1),
    PGpg_collation = PGType(11138, -1),
    PGpg_range = PGType(11139, -1),
    PGpg_toast_2604 = PGType(11140, -1),
    PGpg_toast_2606 = PGType(11141, -1),
    PGpg_toast_2609 = PGType(11142, -1),
    PGpg_toast_1255 = PGType(11143, -1),
    PGpg_toast_2618 = PGType(11144, -1),
    PGpg_toast_3596 = PGType(11145, -1),
    PGpg_toast_2619 = PGType(11146, -1),
    PGpg_toast_2620 = PGType(11147, -1),
    PGpg_toast_2396 = PGType(11148, -1),
    PGpg_toast_2964 = PGType(11149, -1),
    PGpg_roles = PGType(11151, -1),
    PGpg_shadow = PGType(11155, -1),
    PGpg_group = PGType(11158, -1),
    PGpg_user = PGType(11161, -1),
    PGpg_rules = PGType(11164, -1),
    PGpg_views = PGType(11168, -1),
    PGpg_tables = PGType(11172, -1),
    PGpg_matviews = PGType(11176, -1),
    PGpg_indexes = PGType(11180, -1),
    PGpg_stats = PGType(11184, -1),
    PGpg_locks = PGType(11188, -1),
    PGpg_cursors = PGType(11191, -1),
    PGpg_available_extensions = PGType(11194, -1),
    PGpg_available_extension_versions = PGType(11197, -1),
    PGpg_prepared_xacts = PGType(11200, -1),
    PGpg_prepared_statements = PGType(11204, -1),
    PGpg_seclabels = PGType(11207, -1),
    PGpg_settings = PGType(11211, -1),
    PGpg_timezone_abbrevs = PGType(11216, -1),
    PGpg_timezone_names = PGType(11219, -1),
    PGpg_stat_all_tables = PGType(11222, -1),
    PGpg_stat_xact_all_tables = PGType(11226, -1),
    PGpg_stat_sys_tables = PGType(11230, -1),
    PGpg_stat_xact_sys_tables = PGType(11234, -1),
    PGpg_stat_user_tables = PGType(11237, -1),
    PGpg_stat_xact_user_tables = PGType(11241, -1),
    PGpg_statio_all_tables = PGType(11244, -1),
    PGpg_statio_sys_tables = PGType(11248, -1),
    PGpg_statio_user_tables = PGType(11251, -1),
    PGpg_stat_all_indexes = PGType(11254, -1),
    PGpg_stat_sys_indexes = PGType(11258, -1),
    PGpg_stat_user_indexes = PGType(11261, -1),
    PGpg_statio_all_indexes = PGType(11264, -1),
    PGpg_statio_sys_indexes = PGType(11268, -1),
    PGpg_statio_user_indexes = PGType(11271, -1),
    PGpg_statio_all_sequences = PGType(11274, -1),
    PGpg_statio_sys_sequences = PGType(11278, -1),
    PGpg_statio_user_sequences = PGType(11281, -1),
    PGpg_stat_activity = PGType(11284, -1),
    PGpg_stat_replication = PGType(11288, -1),
    PGpg_replication_slots = PGType(11292, -1),
    PGpg_stat_database = PGType(11295, -1),
    PGpg_stat_database_conflicts = PGType(11298, -1),
    PGpg_stat_user_functions = PGType(11301, -1),
    PGpg_stat_xact_user_functions = PGType(11305, -1),
    PGpg_stat_archiver = PGType(11309, -1),
    PGpg_stat_bgwriter = PGType(11312, -1),
    PGpg_user_mappings = PGType(11315, -1),
    PGcardinal_number = PGType(11638, 4),
    PGcharacter_data = PGType(11640, -1),
    PGsql_identifier = PGType(11641, -1),
    PGinformation_schema_catalog_name = PGType(11643, -1),
    PGtime_stamp = PGType(11645, 8),
    PGyes_or_no = PGType(11646, -1),
    PGapplicable_roles = PGType(11649, -1),
    PGadministrable_role_authorizations = PGType(11653, -1),
    PGattributes = PGType(11656, -1),
    PGcharacter_sets = PGType(11660, -1),
    PGcheck_constraint_routine_usage = PGType(11664, -1),
    PGcheck_constraints = PGType(11668, -1),
    PGcollations = PGType(11672, -1),
    PGcollation_character_set_applicability = PGType(11675, -1),
    PGcolumn_domain_usage = PGType(11678, -1),
    PGcolumn_privileges = PGType(11682, -1),
    PGcolumn_udt_usage = PGType(11686, -1),
    PGcolumns = PGType(11690, -1),
    PGconstraint_column_usage = PGType(11694, -1),
    PGconstraint_table_usage = PGType(11698, -1),
    PGdomain_constraints = PGType(11702, -1),
    PGdomain_udt_usage = PGType(11706, -1),
    PGdomains = PGType(11709, -1),
    PGenabled_roles = PGType(11713, -1),
    PGkey_column_usage = PGType(11716, -1),
    PGparameters = PGType(11720, -1),
    PGreferential_constraints = PGType(11724, -1),
    PGrole_column_grants = PGType(11728, -1),
    PGroutine_privileges = PGType(11731, -1),
    PGrole_routine_grants = PGType(11735, -1),
    PGroutines = PGType(11738, -1),
    PGschemata = PGType(11742, -1),
    PGsequences = PGType(11745, -1),
    PGsql_features = PGType(11749, -1),
    PGpg_toast_11748 = PGType(11751, -1),
    PGsql_implementation_info = PGType(11754, -1),
    PGpg_toast_11753 = PGType(11756, -1),
    PGsql_languages = PGType(11759, -1),
    PGpg_toast_11758 = PGType(11761, -1),
    PGsql_packages = PGType(11764, -1),
    PGpg_toast_11763 = PGType(11766, -1),
    PGsql_parts = PGType(11769, -1),
    PGpg_toast_11768 = PGType(11771, -1),
    PGsql_sizing = PGType(11774, -1),
    PGpg_toast_11773 = PGType(11776, -1),
    PGsql_sizing_profiles = PGType(11779, -1),
    PGpg_toast_11778 = PGType(11781, -1),
    PGtable_constraints = PGType(11784, -1),
    PGtable_privileges = PGType(11788, -1),
    PGrole_table_grants = PGType(11792, -1),
    PGtables = PGType(11795, -1),
    PGtriggered_update_columns = PGType(11799, -1),
    PGtriggers = PGType(11803, -1),
    PGudt_privileges = PGType(11807, -1),
    PGrole_udt_grants = PGType(11811, -1),
    PGusage_privileges = PGType(11814, -1),
    PGrole_usage_grants = PGType(11818, -1),
    PGuser_defined_types = PGType(11821, -1),
    PGview_column_usage = PGType(11825, -1),
    PGview_routine_usage = PGType(11829, -1),
    PGview_table_usage = PGType(11833, -1),
    PGviews = PGType(11837, -1),
    PGdata_type_privileges = PGType(11841, -1),
    PGelement_types = PGType(11845, -1),
    PG_pg_foreign_table_columns = PGType(11849, -1),
    PGcolumn_options = PGType(11853, -1),
    PG_pg_foreign_data_wrappers = PGType(11856, -1),
    PGforeign_data_wrapper_options = PGType(11859, -1),
    PGforeign_data_wrappers = PGType(11862, -1),
    PG_pg_foreign_servers = PGType(11865, -1),
    PGforeign_server_options = PGType(11869, -1),
    PGforeign_servers = PGType(11872, -1),
    PG_pg_foreign_tables = PGType(11875, -1),
    PGforeign_table_options = PGType(11879, -1),
    PGforeign_tables = PGType(11882, -1),
    PG_pg_user_mappings = PGType(11885, -1),
    PGuser_mapping_options = PGType(11889, -1),
    PGuser_mappings = PGType(11893, -1),
}