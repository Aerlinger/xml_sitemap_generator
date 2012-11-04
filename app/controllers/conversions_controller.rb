class ConversionsController < ApplicationController


  # GET /conversions
  # GET /conversions.json
  def index
    @conversions = Conversion.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @conversions }
    end
  end

  # GET /conversions/1
  # GET /conversions/1.json
  def show
    @conversion = Conversion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @conversion }
    end
  end

  # GET /conversions/new
  # GET /conversions/new.json
  def new
    @conversion = Conversion.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @conversion }
    end
  end

  # GET /conversions/1/edit
  def edit
    @conversion = Conversion.find(params[:id])
  end

  # POST /conversions
  # POST /conversions.json
  def create
    @conversion = Conversion.new(params[:conversion])

    respond_to do |format|
      if @conversion.save
        format.html { redirect_to @conversion, notice: 'Conversion was successfully created.' }
        format.json { render json: @conversion, status: :created, location: @conversion }
      else
        format.html { render action: "new" }
        format.json { render json: @conversion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /conversions/1
  # PUT /conversions/1.json
  def update
    @conversion = Conversion.find(params[:id])

    respond_to do |format|
      if @conversion.update_attributes(params[:conversion])
        format.html { redirect_to @conversion, notice: 'Conversion was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @conversion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conversions/1
  # DELETE /conversions/1.json
  def destroy
    @conversion = Conversion.find(params[:id])
    @conversion.destroy

    respond_to do |format|
      format.html { redirect_to conversions_url }
      format.json { head :no_content }
    end
  end
end
