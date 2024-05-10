import 'package:da_order/common/model/cursor_pagination_model.dart';
import 'package:da_order/common/model/model_with_id.dart';
import 'package:da_order/common/provider/pagination_provider.dart';
import 'package:da_order/common/utils/pagination_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef PaginationWidgetBuilder<T extends IModelWithId> = Widget Function(
    BuildContext context, int index, T model);

class PaginationListView<T extends IModelWithId>
    extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationProvider, CursorPaginationBase>
      provider;
  final PaginationWidgetBuilder<T> itemBuilder;

  const PaginationListView({
    required this.provider,
    required this.itemBuilder,
    super.key,
  });

  @override
  ConsumerState<PaginationListView> createState() => _PaginationListViewState();
}

class _PaginationListViewState<T extends IModelWithId>
    extends ConsumerState<PaginationListView> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  void listener() {
    PaginationUtils.paginate(
      scrollController: controller,
      provider: ref.read(widget.provider.notifier),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
