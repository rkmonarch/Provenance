part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}
class ProductLoadEvent extends ProductEvent {
  final String productID;
  ProductLoadEvent({required this.productID});
}