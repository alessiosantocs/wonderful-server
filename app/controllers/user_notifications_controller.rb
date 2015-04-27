class UserNotificationsController < ApplicationController
  before_action :set_user
  before_action :set_user_notification, only: [:show, :edit, :update, :destroy]

  # GET /notifications
  # GET /notifications.json
  # def index
  #   @user_notifications = Notification.all
  #   @user_notifications = @user.notifications if @user
  #   @user_notifications = @user_notifications.order(created_at: :desc)
  # end

  # GET /notifications/1
  # GET /notifications/1.json
  # def show
  # end

  # GET /notifications/new
  # def new
  #   @user_notification = Notification.new
  # end

  # GET /notifications/1/edit
  # def edit
  # end

  # POST /notifications
  # POST /notifications.json
  # def create
  #   @user_notification = Notification.new(user_notification_params)
  #
  #   respond_to do |format|
  #     if @user_notification.save
  #       format.html { redirect_to @user_notification, notice: 'Notification was successfully created.' }
  #       format.json { render action: 'show', status: :created, location: @user_notification }
  #     else
  #       format.html { render action: 'new' }
  #       format.json { render json: @user_notification.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /notifications/1
  # PATCH/PUT /notifications/1.json
  def update
    respond_to do |format|
      if @user_notification.update(user_notification_params)
        format.html { redirect_to @user_notification, notice: 'Notification was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user_notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.json
  # def destroy
  #   @user_notification.destroy
  #   respond_to do |format|
  #     format.html { redirect_to notifications_url }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_notification
      @user_notification = @user.user_notifications.find(params[:id])
    end

    def set_user
      @user = User.find_by_device_uuid(params[:user_id]) || User.find_by_id(params[:user_id]) if params[:user_id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_notification_params
      parsed_params = params.require(:user_notification).permit(:loved_at)

      # If loved_at is a Number
      if parsed_params[:loved_at]
        # Set to nil if 0
        parsed_params[:loved_at] = nil if parsed_params[:loved_at].to_s == "0"
        # Set to current DateTime if 1
        parsed_params[:loved_at] = DateTime.now if parsed_params[:loved_at].to_s == "1"
      end

      parsed_params
    end
end
