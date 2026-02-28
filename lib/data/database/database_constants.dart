/// Database configuration
const String dbName = 'daycount.db';
const int dbVersion = 1;

/// Table: ddays
const String tableDdays = 'ddays';
const String colId = 'id';
const String colTitle = 'title';
const String colTargetDate = 'target_date';
const String colCategory = 'category';
const String colEmoji = 'emoji';
const String colThemeId = 'theme_id';
const String colIsCountUp = 'is_count_up';
const String colIsFavorite = 'is_favorite';
const String colMemo = 'memo';
const String colNotifyEnabled = 'notify_enabled';
const String colSortOrder = 'sort_order';
const String colCreatedAt = 'created_at';
const String colUpdatedAt = 'updated_at';

/// Table: milestones
const String tableMilestones = 'milestones';
const String colMilestoneId = 'id';
const String colMilestoneDdayId = 'dday_id';
const String colMilestoneDays = 'days';
const String colMilestoneLabel = 'label';
const String colMilestoneIsCustom = 'is_custom';
const String colMilestoneNotifyBefore = 'notify_before';

/// Table: settings
const String tableSettings = 'settings';
const String colSettingsKey = 'key';
const String colSettingsValue = 'value';

/// Index names
const String idxDdaysCategory = 'idx_ddays_category';
const String idxDdaysTargetDate = 'idx_ddays_target_date';
const String idxMilestonesDdayId = 'idx_milestones_dday_id';
