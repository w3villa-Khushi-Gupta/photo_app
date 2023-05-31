class RegistrationsController < Devise::RegistrationsController
    def create
      build_resource(sign_up_params)
  
      resource.class.transaction do
        resource.save
        yield resource if block_given?
        if resource.persisted?
          @payment = Payment.new(email: params[:user][:email],
                                 token: params[:payment][:token],
                                 user_id: resource.id)
          flash[:error] = "Please check registration errors" unless @payment.valid?
  
          begin
            @payment.process_payment
            @payment.save
          rescue Exception => e
            flash[:error] = e.message
            resource.destroy
            puts 'Payment failed'
            render :new and return
          end
  
          if resource.active_for_authentication?
            set_flash_message!(:notice, :signed_up)
            sign_up(resource_name, resource)
            respond_with resource, location: after_sign_up_path_for(resource)
          else
            set_flash_message!(:notice, :"signed_up_but_#{resource.inactive_message}")
            expire_data_after_sign_in!
            respond_with resource, location: after_inactive_sign_up_path_for(resource)
          end
        else
          clean_up_passwords resource
          set_minimum_password_length
          respond_with resource
        end
      end
    end
  
    # def confirm_payment
    #     payment = Payment.find(params[:id])
    #     payment_intent_id = payment.payment_intent_id
    
    #     payment_intent = payment.confirm_payment(payment_intent_id)
    
    #     if payment_intent.status == 'succeeded'
    #       # Payment succeeded, handle success logic here
    #       flash[:success] = 'Payment confirmed successfully!'
    #       redirect_to payment_path(payment)
    #     else
    #       # Payment failed, handle failure logic here
    #       flash[:error] = 'Payment confirmation failed.'
    #       redirect_to root_path
    #     end
    #   end

    protected
  
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:payment])
    end
  end
  