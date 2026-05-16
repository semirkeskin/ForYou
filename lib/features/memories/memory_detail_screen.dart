import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';
import '../../data/models/memory_item.dart';

class MemoryDetailScreen extends StatefulWidget {
  const MemoryDetailScreen({
    super.key,
    required this.memories,
    required this.initialIndex,
  });

  final List<MemoryItem> memories;
  final int initialIndex;

  @override
  State<MemoryDetailScreen> createState() => _MemoryDetailScreenState();
}

class _MemoryDetailScreenState extends State<MemoryDetailScreen> {
  late final PageController _controller;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.memories.length - 1);
    _controller = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.memories.length;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: total,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              final memory = widget.memories[index];
              return _MemoryPage(memory: memory);
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                child: Row(
                  children: [
                    Material(
                      color: Colors.black.withOpacity(0.35),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => Navigator.of(context).maybePop(),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (total > 1)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_currentIndex + 1} / $total',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MemoryPage extends StatelessWidget {
  const _MemoryPage({required this.memory});

  final MemoryItem memory;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: Image.asset(
            memory.image,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stack) => const _PhotoFallback(),
          ),
        ),
        if (memory.hasAnyText)
          Positioned(
            left: 16,
            right: 16,
            bottom: 28,
            child: _GlassCaption(memory: memory),
          ),
      ],
    );
  }
}

class _GlassCaption extends StatelessWidget {
  const _GlassCaption({required this.memory});

  final MemoryItem memory;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.18),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (memory.title != null)
                  Text(
                    memory.title!,
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                if (memory.date != null) ...[
                  if (memory.title != null) const SizedBox(height: 2),
                  Text(
                    memory.date!,
                    style: AppTextStyles.bodyMuted.copyWith(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 13,
                    ),
                  ),
                ],
                if (memory.description != null) ...[
                  if (memory.title != null || memory.date != null)
                    const SizedBox(height: 10),
                  Text(
                    memory.description!,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.55,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PhotoFallback extends StatelessWidget {
  const _PhotoFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade900,
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          size: 64,
          color: Colors.white24,
        ),
      ),
    );
  }
}
