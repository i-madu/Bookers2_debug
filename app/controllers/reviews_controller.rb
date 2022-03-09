class ReviewsController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    @review = current_user.reviews.new(review_params)
    @review.book_id = @book.id
    review_count = Review.where(book_id: params[:book_id]).where(user_id: current_user.id).count
    # バリデーションによるエラーがあるか判定
    if @review.valid?
      # バリデーションエラーが無い、且つレビューを一度もしたことない場合
      if review_count < 1
        @review.save
        redirect_to shop_reviews_path(@shop), notice: "レビューを保存しました"
      else
        redirect_to shop_reviews_path(@shop), notice: "レビューの投稿は一度までです"
      end
    else
      flash.now[:alert] = "レビューの保存に失敗しました"
      render :new
    end
  end
  
   private

  def review_params
    params.require(:review).permit(:star)
  end
  
  
end
