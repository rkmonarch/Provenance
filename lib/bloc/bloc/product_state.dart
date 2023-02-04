part of 'product_bloc.dart';

@immutable
abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductSuccess extends ProductState {
  final ProductModel model;
  ProductSuccess({required this.model});
}

class ProductNotFound extends ProductState {}
