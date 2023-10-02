/* The following generic test checks if a column is always strictly larger than zero */

{% test column_is_strictly_positive(model, column_name) %}

select *
from {{ model }}
where {{ column_name }} <= 0

{% endtest %}