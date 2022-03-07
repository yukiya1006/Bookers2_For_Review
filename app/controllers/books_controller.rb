class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

# findメソッドでモデルと紐づくテーブルのDBからbookのレコードを1つ取得
# newメソッドでbookコメントを作成
  def show
    @book = Book.find(params[:id])
    @book_comment = BookComment.new
    @review_count = Book.where(id: Book.new).where(user_id: current_user.id).count
  end

# allメソッドでモデルと紐づくbookのすべてのレコードを取得
# newメソッドでbookを作成(bookクラスをインスタンス化)

  def index
     @book = Book.new
     @review_count = Book.where(id: params[:id]).where(user_id: current_user.id).count
  if params[:button].to_i == 1
     @books = Book.all.order(created_at: :desc)
    # button1の処理
  elsif params[:button].to_i == 2
     @books = Book.all.order(star: :desc)
    # button2の処理
  else
     @books = Book.all
  end
  end

# newメソッドでbookクラスをインスタンス化(カラムを引数として渡す)
# user_id = current_user.idでログインしている本人かどうか確認
# saveメソッドでbook作成
# renderはコントローラーを介さず直接viewを表示させるため表示先の変数を表記
  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end


  def edit
    @book = Book.find(params[:id])
    @review_count = Book.where(id: params[:id]).where(user_id: current_user.id).count
    @user = User.new
    if @book.user.id != current_user.id
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :star, :category)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end
end