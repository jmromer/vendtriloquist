# frozen_string_literal: true

# Exception namespace
class VendingMachineException < StandardError; end

# Exception types
class NavigationException < VendingMachineException; end
class PaymentException < VendingMachineException; end

# Navigation exceptions
class Back < NavigationException; end
class Route < NavigationException; end
class Quit < NavigationException; end
class ReturnToMain < NavigationException; end
class RoutingError < NavigationException; end

# Payment exceptions
class BalanceRemaining < PaymentException; end
class PaymentFailure < PaymentException; end

# Payment failures
class InsufficientChange < PaymentFailure; end
