class ListDataSource{
    ListDataSource(this.display, this.value);

    String display;
    String value;

    asMap(){
        return {
        "display": display,
        "value": value
        };
    }
}