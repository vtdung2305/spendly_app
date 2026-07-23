import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/budget_item.dart';

abstract class IBudgetRepository {
  Future<Either<Failure, List<BudgetItem>>> getBudgets();
}
