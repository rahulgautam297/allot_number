class PhoneNumber < ApplicationRecord
  validates :number, presence: true, length: { is: 10, message: "Phone number should be of 10 digits." }
  validates :custom, inclusion: { in: [true, false] }

  def allot_number(all_non_custom_numbers)
    all_non_custom_numbers ||= PhoneNumber.where(custom: false)
    if all_non_custom_numbers.count == 0
      self.assign_attributes({number: "1111111111", custom: false})
    else
      incremented_non_custom_number = all_non_custom_numbers.last.number.to_i + 1
      all_custom_numbers = PhoneNumber.where(custom: true).pluck(:number)
      number = check_number_exists(incremented_non_custom_number.to_s, false, all_custom_numbers)
      self.assign_attributes({number: number, custom: false})
    end
  end
  # Wrote this one to avoid extra database queries.
  def check_number_is_within_limit(number)
    if number < 1111111111 || number > 9999999999
      return false
    end
    return true
  end

  def allot_custom_number(number)
    if !self.check_number_is_within_limit(number.to_i)
      return
    end
    all_non_custom_numbers = PhoneNumber.where(custom: false)
    largest_non_custom_number_object = all_non_custom_numbers.last
    if !largest_non_custom_number_object.nil? && 
                                        number.to_i <= largest_non_custom_number_object.number.to_i
      allot_number(all_non_custom_numbers)
    else
      all_custom_numbers = PhoneNumber.where(custom: true).pluck(:number)
      if check_number_exists(number.to_s, true, all_custom_numbers)
        allot_number(all_non_custom_numbers)
      else
        self.assign_attributes({number: number.to_s, custom: true})
      end
    end
  end

  def check_number_exists(number, custom, all_custom_numbers)
    if all_custom_numbers.include?(number) && custom 
      true
    elsif !all_custom_numbers.include?(number) && custom 
      false
    elsif all_custom_numbers.include?(number) && !custom
      number = number.to_i + 1
      return check_number_exists(number.to_s, false, all_custom_numbers)
    elsif !all_custom_numbers.include?(number) && !custom
      return number
    end
  end
end
