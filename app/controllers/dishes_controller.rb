class DishesController < ApplicationController
  def index
    if params.has_key?("q")
      @q = Dish.ransack(params.fetch("q"))
      @dishes = @q.result(:distinct => true).includes(:cuisine, :bookmarks, :fans, :specialists).page(params.fetch("page")).per(10)

    else
      @q = Dish.ransack(nil)
      @dishes = @q.result(:distinct => true).includes(:cuisine, :bookmarks, :fans, :specialists).page(nil).per(10)

    end

    render("dishes/index.html.erb")
  end

  def show
    @bookmark = Bookmark.new
    @dish = Dish.find(params.fetch("id"))

    render("dishes/show.html.erb")
  end

  def new
    @dish = Dish.new

    render("dishes/new.html.erb")
  end

  def create
    @dish = Dish.new

    @dish.name = params.fetch("name")
    @dish.cuisine_id = params.fetch("cuisine_id")

    save_status = @dish.save

    if save_status == true
      referer = URI(request.referer).path

      case referer
      when "/dishes/new", "/create_dish"
        redirect_to("/dishes")
      else
        redirect_back(:fallback_location => "/", :notice => "Dish created successfully.")
      end
    else
      render("dishes/new.html.erb")
    end
  end

  def edit
    @dish = Dish.find(params.fetch("id"))

    render("dishes/edit.html.erb")
  end

  def update
    @dish = Dish.find(params.fetch("id"))

    @dish.name = params.fetch("name")
    @dish.cuisine_id = params.fetch("cuisine_id")

    save_status = @dish.save

    if save_status == true
      referer = URI(request.referer).path

      case referer
      when "/dishes/#{@dish.id}/edit", "/update_dish"
        redirect_to("/dishes/#{@dish.id}", :notice => "Dish updated successfully.")
      else
        redirect_back(:fallback_location => "/", :notice => "Dish updated successfully.")
      end
    else
      render("dishes/edit.html.erb")
    end
  end

  def destroy
    @dish = Dish.find(params.fetch("id"))

    @dish.destroy

    if URI(request.referer).path == "/dishes/#{@dish.id}"
      redirect_to("/", :notice => "Dish deleted.")
    else
      redirect_back(:fallback_location => "/", :notice => "Dish deleted.")
    end
  end
end
