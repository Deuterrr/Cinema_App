import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchField extends StatefulWidget {
  final TextEditingController controller;
  final bool isEmptyText;
  final bool suffixIcon;
  final bool requestFocus;
  final String searchText;

  const SearchField({
    Key? key,
    required this.controller,
    required this.isEmptyText,
    required this.suffixIcon,
    required this.requestFocus,
    required this.searchText
  });

  @override
  State<StatefulWidget> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final FocusNode focusNode = FocusNode();   // for opening keyboard directly

  @override
  void initState() {
    super.initState();
    if (widget.requestFocus) {
      Future.delayed(Duration(milliseconds: 300), () {
        FocusScope.of(context).requestFocus(focusNode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: widget.isEmptyText ? 500 : 500,
            child: Container(
              height: 42,
              padding: const EdgeInsets.fromLTRB(28, 4, 6, 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF), // White
                border: Border.all(
                  color: const Color(0xFF0E2522), // Black
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(32),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0.8, 1.6),
                    color: Color(0xFF0E2522), // Black
                  ),
                ],
              ),
              
              child: TextField(
                controller: widget.controller,
                focusNode: focusNode,
                style: const TextStyle(
                  fontSize: 15,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0E2522), // Black
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 9), 
                  filled: true,
                  fillColor: Colors.transparent,
                  hintText: widget.searchText,
                  hintStyle: TextStyle(
                    fontSize: 15,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500,
                    color: Color(0xff000000).withOpacity(0.5),
                  ),
                  border: InputBorder.none,
                  suffixIcon: widget.isEmptyText
                      ? Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: SvgPicture.asset(
                            'assets/icon/Search.svg',
                            width: 15,
                            height: 15,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              widget.controller.clear();
                            },
                            child: const Icon(
                              Icons.cancel,
                              size: 24,
                              color: Color(0xFF0E2522), // Black
                            ),
                          ),
                        ),
                ),
              ),

            ),
          ),
        ),
      ],
    );
  }
}
