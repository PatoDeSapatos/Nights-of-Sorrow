
function inventory_draw_recipes(){

for (var i = 0; i < array_length(recipes); ++i) {
    draw_text(items_box_x, 20, get_item_by_id( recipes[i].result_id ).name);
}

}