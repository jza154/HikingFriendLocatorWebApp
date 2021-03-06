class PostsController < InheritedResources::Base
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :post_owner, only: [:edit, :update, :destroy]
  
  # GET /posts
  # GET /posts.json
  # def index
  #   @posts = Post.all
  #   if params[:search]
  #     @posts = Post.search(params[:search]).order("created_at DESC")
  #   else
  #     @posts = Post.all.order('created_at DESC')
  #   end
  # end
  
  
  def index
  if params[:search].present?
    @posts = Post.near(params[:search], 50, :order => :distance)
  else
    @posts = Post.all
  end
  end
  
  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :trail_name, :region,:difficulty,:distance,:season,:location,:image,:latitude,:longitude)
    end
    
    def post_owner
     unless @post.user_id == current_user.id
      flash[:notice] = 'Access denied as you are not the owner of this Post'
      redirect_to post_path
     end
    end
end# # s# # s# 
