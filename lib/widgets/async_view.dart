import 'package:flutter/material.dart';

//Generic async UI wrapper around [FutureBuilder] that uniformly handles
// loading / error / empty / data states
class AsyncView<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(T data) onData;
  final bool Function(T data)? isEmpty;
  final Widget? emptyWidget;
  final String emptyText;
  final VoidCallback? onRetry;

  const AsyncView({
    super.key,
    required this.future,
    required this.onData,
    this.isEmpty,
    this.emptyWidget,
    this.emptyText = 'No data available',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error, size: 40),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
                if (onRetry != null) ...[
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: onRetry,
                    child: const Text('Retry'),
                  ),
                ],
              ],
            ),
          );
        }
        final data = snapshot.data;
        if (data == null) {
          return emptyWidget ?? Center(child: Text(emptyText));
        }
        if (isEmpty != null && isEmpty!(data)) {
          return emptyWidget ?? Center(child: Text(emptyText));
        }
        return onData(data);
      },
    );
  }
}
