/* The following generic test checks if a column is always positive */

{% test column_is_positive(model, column_name) %}

select *
from {{ model }}
where {{ column_name }} <= 0

{% endtest %}