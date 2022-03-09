class SearchesController < ApplicationController
 before_action :authenticate_user!,except: [:index, :show, :followers, :followings]

def search
  @range = params[:range]
  if @range == "User"
    @users = User.looks(params[:search], params[:word])
  else
    @books = Book.looks(params[:search], params[:word])
  end
end

end


