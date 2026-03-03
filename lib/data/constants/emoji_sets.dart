/// Recommended emoji sets per category.
///
/// Each category maps to a list of 10 emojis.
/// The first emoji in each list is the category's default.
const Map<String, List<String>> emojiSets = {
  'anniversary': [
    '\u{1F389}', // 🎉
    '\u{1F38A}', // 🎊
    '\u{2B50}',  // ⭐
    '\u{1F3C6}', // 🏆
    '\u{1F3AF}', // 🎯
    '\u{1F4CC}', // 📌
    '\u{1F514}', // 🔔
    '\u{1F680}', // 🚀
    '\u{1F31F}', // 🌟
    '\u{1F381}', // 🎁
  ],
  'couple': [
    '\u{1F495}', // 💕
    '\u{2764}',  // ❤️
    '\u{1F491}', // 💑
    '\u{1F48D}', // 💍
    '\u{1F339}', // 🌹
    '\u{1F49D}', // 💝
    '\u{1F60D}', // 😍
    '\u{1F498}', // 💘
    '\u{1F970}', // 🥰
    '\u{1F48F}', // 💏
  ],
  'exam': [
    '\u{1F4DA}', // 📚
    '\u{270F}',  // ✏️
    '\u{1F393}', // 🎓
    '\u{1F4DD}', // 📝
    '\u{1F4AA}', // 💪
    '\u{1F9E0}', // 🧠
    '\u{1F4D6}', // 📖
    '\u{1F392}', // 🎒
    '\u{1F4D0}', // 📐
    '\u{1F3EB}', // 🏫
  ],
  'travel': [
    '\u{2708}',  // ✈️
    '\u{1F30E}', // 🌎
    '\u{1F3D6}', // 🏖️
    '\u{1F5FC}', // 🗼
    '\u{26F0}',  // ⛰️
    '\u{1F6A2}', // 🚢
    '\u{1F5FA}', // 🗺️
    '\u{1F9F3}', // 🧳
    '\u{1F3D5}', // 🏕️
    '\u{1F3A2}', // 🎢
  ],
  'birthday': [
    '\u{1F382}', // 🎂
    '\u{1F388}', // 🎈
    '\u{1F381}', // 🎁
    '\u{1F973}', // 🥳
    '\u{1F38A}', // 🎊
    '\u{1F56F}', // 🕯️
    '\u{1F370}', // 🍰
    '\u{1F389}', // 🎉
    '\u{1F380}', // 🎀
    '\u{1F9C1}', // 🧁
  ],
  'baby': [
    '\u{1F476}', // 👶
    '\u{1F37C}', // 🍼
    '\u{1F382}', // 🎂
    '\u{1F463}', // 👣
    '\u{1F9F8}', // 🧸
    '\u{1F31F}', // 🌟
    '\u{1F496}', // 💖
    '\u{1F36D}', // 🍭
    '\u{1F47C}', // 👼
    '\u{1F380}', // 🎀
  ],
  'custom': [
    '\u{26A1}',  // ⚡
    '\u{1F4C5}', // 📅
    '\u{1F3AF}', // 🎯
    '\u{1F4A1}', // 💡
    '\u{1F525}', // 🔥
    '\u{1F308}', // 🌈
    '\u{1F3AA}', // 🎪
    '\u{1F3E0}', // 🏠
    '\u{1F4BC}', // 💼
    '\u{1F338}', // 🌸
  ],
};

/// Returns the default emoji for a category.
String defaultEmojiForCategory(String category) {
  return emojiSets[category]?.first ?? '\u{1F4C5}'; // 📅 fallback
}
