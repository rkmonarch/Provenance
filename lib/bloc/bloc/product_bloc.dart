import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:trust_chain/Repo/product_repo.dart';
import 'package:trust_chain/resources/ui_helpers.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductRepo productRepo;
  ProductBloc({required this.productRepo}) : super(ProductInitial()) {
    on<ProductEvent>((event, emit) async {
      if (event is ProductLoadEvent) {
        emit.call(ProductLoading());
        try {
          final ProductModel model = await productRepo.getProduct(
            productID: event.productID,
          );
          emit.call(ProductSuccess(
            model: model
          ));
        } catch (e) {
          lg.wtf(e.toString());
          emit.call(ProductNotFound());
        }
      }
    });
  }
}
