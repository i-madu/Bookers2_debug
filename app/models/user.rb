class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy


  #フォローする/　されるの関係
  #has_many :任意の名前,class_name: "モデル名",この状態ではRelationshipのuser_idを探しに行ってしまうため、参照するカラムをforeign_keyで指定。
  has_many :relationships,class_name: "Relationship", foreign_key: "follower_id",dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id",dependent: :destroy

  #最後に、以下情報が取れるようにする
#”@userがフォローしているUser一覧” ⇒ @user.followings　(followedsは英語的におかしいため)
#”@userがフォローされているUser一覧” ⇒ @user.followers
#ここでrailsはfollowings、followersの表記より、
#(単数形)_idがRelationshipテーブルにあるかを探しに行くが、followingsの方は存在していない。
#そのため、sourceを用いて、Relationshipテーブルの参照先カラムを指定する。
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower



  has_one_attached :profile_image

  validates :name, presence: true, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }


  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  # フォローしたときの処理
def follow(user_id)
  relationships.create(followed_id: user_id)
end
# フォローを外すときの処理
def unfollow(user_id)
  relationships.find_by(followed_id: user_id).destroy
end
# フォローしているか判定
def following?(user)
  followings.include?(user)
end


# 検索方法分岐定義
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end




end
