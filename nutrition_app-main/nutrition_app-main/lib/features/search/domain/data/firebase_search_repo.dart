// lib/custom_search_bar.dart

import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final ValueChanged<String>? onSearchChanged;
  final String? hintText;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const CustomSearchBar({
    super.key,
    this.onSearchChanged,
    this.hintText,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.iconColor = Colors.grey,
    this.borderRadius = 10.0,
    this.padding = const EdgeInsets.all(8.0),
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    if (widget.onSearchChanged != null) {
      widget.onSearchChanged!(_searchController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding!,
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: widget.textColor),
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Search',
          hintStyle: TextStyle(color: widget.textColor?.withOpacity(0.6)),
          filled: true,
          fillColor: widget.backgroundColor,
          prefixIcon: Icon(Icons.search, color: widget.iconColor),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: widget.iconColor),
                  onPressed: () {
                    _searchController.clear();
                    if (widget.onSearchChanged != null) {
                      widget.onSearchChanged!('');
                    }
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
