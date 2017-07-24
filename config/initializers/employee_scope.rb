# module Devise
#   module Strategies
#     class EmployeeScope < Base
#
#       def valid?
#         params[:user][:email] || params[:user][:password]
#       end
#
#       def authenticate!
#         user = Employee.find_by_email(params[:user][:email])
#         if user.nil?
#           fail!('Employee login failed')
#         elsif user.valid_password?(params[:user][:password])
#           success!(user)
#         else
#           fail!('Invalid password')
#         end
#       end
#     end
#   end
# end