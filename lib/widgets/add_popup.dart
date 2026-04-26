import 'package:flutter/material.dart';
import 'package:cash_compass/constants/colors.dart' as clr;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;

class AddPopup extends StatefulWidget {
  final String popupTitle;
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onEmojiSelected;

  const AddPopup({
    super.key,
    required this.popupTitle,
    required this.onCancel,
    required this.onSave,
    required this.controller,
    required this.hintText,
    this.onEmojiSelected,
  });

  @override
  State<AddPopup> createState() => _AddPopupState();
}

class _AddPopupState extends State<AddPopup> {
  bool _showEmojis = false;
  String _selectedEmoji = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: clr.matteblack,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 15.0,
      ),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                widget.popupTitle,
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 25.0,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: widget.onCancel,
                icon: Icon(
                  Icons.cancel,
                  size: 30.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _showEmojis = !_showEmojis;
                  });
                  if (!_showEmojis) {
                    FocusScope.of(context).unfocus();
                  }
                },
                icon: _selectedEmoji.isEmpty
                    ? const Icon(
                        Icons.emoji_emotions,
                        color: Colors.white,
                      )
                    : Text(
                        _selectedEmoji,
                        style: const TextStyle(
                          fontSize: 30,
                        ),
                      ),
              ),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  onTap: () =>
                      setState(() => _showEmojis = false),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    border: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          if (_showEmojis)
            SizedBox(
              height: 200,
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  setState(() {
                    _selectedEmoji = emoji.emoji;
                    _showEmojis = false;
                  });
                  widget.onEmojiSelected?.call(emoji.emoji);
                },
                config: Config(
                  height: 280,
                  checkPlatformCompatibility: true,
                  emojiViewConfig: EmojiViewConfig(
                    emojiSizeMax:
                        28 *
                        (foundation.defaultTargetPlatform ==
                                TargetPlatform.iOS
                            ? 1.2
                            : 1.0),
                    verticalSpacing: 0,
                    horizontalSpacing: 0,
                    gridPadding: EdgeInsets.zero,
                    backgroundColor: clr.matteblack,
                    loadingIndicator:
                        const SizedBox.shrink(),
                    buttonMode: ButtonMode.MATERIAL,
                  ),
                  skinToneConfig: const SkinToneConfig(
                    enabled: true,
                    dialogBackgroundColor: Color(
                      0xFF2A2A2A,
                    ),
                    indicatorColor: Colors.white,
                  ),
                  categoryViewConfig: CategoryViewConfig(
                    backgroundColor: clr.matteblack,
                    iconColor: Colors.white54,
                    iconColorSelected: clr.green,
                    indicatorColor: clr.green,
                    dividerColor: Colors.transparent,
                    recentTabBehavior:
                        RecentTabBehavior.RECENT,
                  ),
                  bottomActionBarConfig:
                      BottomActionBarConfig(
                        backgroundColor: clr.matteblack,
                        buttonColor: clr.matteblack,
                        buttonIconColor: Colors.white54,
                      ),
                  searchViewConfig: SearchViewConfig(
                    backgroundColor: clr.matteblack,
                    buttonIconColor: Colors.white54,
                    hintText: 'Search emoji...',
                    hintTextStyle: const TextStyle(
                      color: Colors.white38,
                    ),
                    inputTextStyle: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20.0),
          TextButton(
            onPressed: widget.onSave,
            style: TextButton.styleFrom(
              backgroundColor: clr.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(
                  5,
                ),
              ),
            ),
            child: SizedBox(
              width: 100.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.save,
                    color: Colors.white,
                    size: 23.0,
                  ),
                  const SizedBox(width: 15.0),
                  Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}