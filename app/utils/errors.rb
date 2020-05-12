# frozen_string_literal: true

class VendingMachineException < StandardError; end

class MenuException < VendingMachineException; end
class ReturnToMainMenu < MenuException; end
class Quit < MenuException; end

class PaymentException < VendingMachineException; end
class BalanceRemaining < PaymentException; end
class PaymentFailure < PaymentException; end
class InsufficientChange < PaymentFailure; end
