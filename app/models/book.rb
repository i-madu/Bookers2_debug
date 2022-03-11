class Book < ApplicationRecord
  belongs_to :user

  #コメント機能
  has_many :book_comments, dependent: :destroy
  validates :title, presence: true
  validates :body,presence:true,length:{maximum:200}


  #いいね機能
  has_many :favorites, dependent: :destroy
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  # 検索方法分岐定義
  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end

  # ソート機能
  scope :latest, -> {order(created_at: :desc)}
  scope :stars, -> {order(star: :desc)}



end
