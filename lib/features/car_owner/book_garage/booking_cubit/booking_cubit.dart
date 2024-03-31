import 'package:flutter_bloc/flutter_bloc.dart';

class CompleteBookingCubit extends Cubit<bool> {
  CompleteBookingCubit() : super(false);

  void hasBooked(){
    emit(true);
  }
  void notYetBooked(){
    emit(false);
  }
}

final hasBookedCubit = CompleteBookingCubit();