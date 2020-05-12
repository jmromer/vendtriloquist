# frozen_string_literal: true

# Exception namespace
class VendingMachineException < StandardError; end

# Navigation exceptions
class NavigationException < VendingMachineException; end

class Back < NavigationException; end
class Quit < NavigationException; end
class ReturnToMain < NavigationException; end
class Route < NavigationException; end
class RoutingFailure < NavigationException; end

# Payment failures
class PaymentException < VendingMachineException; end
class PaymentFailure < PaymentException; end

class BalanceRemaining < PaymentException; end
class InsufficientChange < PaymentFailure; end
class PaymentInvalid < PaymentFailure; end
