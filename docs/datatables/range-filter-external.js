/*
 * Custom JS File
 */

var minValue = '';
var maxValue = '';

var minYear = '';
var minMonth = '';
var minDay = '';

var maxYear = '';
var maxMonth = '';
var maxDay = '';

var columnID = -1;

var dates = {
	convert:function(d) {
		return (
			d.constructor === Date ? d :
			d.constructor === Array ? new Date(d[0], d[1], d[2]) :
			d.constructor === Number ? new Date(d) :
			d.constructor === String ? new Date(d) :
			typeof d === "object" ? new Date(d.year, d.month, d.date) :
			NaN
		);
	},
	compare:function(a, b) {
		return (
			isFinite(a = this.convert(a).valueOf()) &&
			isFinite(b = this.convert(b).valueOf()) ?
			(a > b) - (a < b) :
			NaN
		);
	},
	inRange:function(d, start, end) {
	return (
			isFinite(d = this.convert(d).valueOf()) &&
			isFinite(start = this.convert(start).valueOf()) &&
			isFinite(end = this.convert(end).valueOf()) ?
			start <= d && d <= end :
			NaN
		);
	}
}

$.fn.dataTable.ext.search.push(
		
	function(settings, data, dataIndex) {
		
		if (columnID > -1) {
			
			// Filtriranje datumskih vrednosti
			if (minYear != '' && maxYear != '') {
				
				var min = minYear;
				var max = maxYear;
				
				if (minMonth != '') {
					min = min + '-' + minMonth;
					if (minDay != '') {
						min = min + '-' + minDay;
					}
				}
				
				if (maxMonth != '') {
					max = max + '-' + maxMonth;
					if (maxDay != '') {
						max = max + '-' + maxDay;
					}
				}
				
				var targetColumn = data[columnID];
				
				if (dates.inRange(targetColumn, min, max)) {
					return true;
				}
				return false;
				
			// Filtriranje navadnih številčnih vrednosti
			} else if (minValue != '' && maxValue != '') {
				
				var min = parseInt(minValue, 10);
				var max = parseInt(maxValue, 10);
				var columnData = parseFloat(data[columnID]) || 0;
				
				if ((isNaN(min) && isNaN(max)) || (isNaN(min) && columnData <= max) || (min <= columnData && isNaN(max)) || (min <= columnData && columnData <= max)) {
					return true;
				}
				return false;
				
			} else {
				return true;
			}
			
		} else {
			return true;
		}
		
	}
	
);

$(document).ready(function() {
	
	var table = $('.targetTable').DataTable({
		dom: 'Bfrtip',
		buttons: [
			'colvis',
			/*{
				extend: 'copyHtml5',
				exportOptions: {
					columns: ':visible'
				}
			},*/
			{
				extend: 'csvHtml5',
				exportOptions: {
					columns: ':visible'
				}
			},
			{
				extend: 'excelHtml5',
				exportOptions: {
					columns: ':visible'
				}
			},
			{
				extend: 'pdfHtml5',
				exportOptions: {
					columns: ':visible'
				}
			}
		],
		colReorder: true,
		initComplete : function() {
			var index = 0;
			var filters = $('select.filterSelect');
			this.api().columns(columnIDs).every(function () {
				var column = this;
				var select = $(filters[index]);
				column.data().unique().sort().each(function (d, j) {
					var cnt = 0;
					column.data().each(function (m) {
						if (d == m) {cnt++;}
					});
					if (d != '') {
						select.append('<option value="' + d + '">' + d + ' (' + cnt + ')</option>')
					}
				});
				index++;
			});
		},
		"oLanguage": {
			"sProcessing": "Obdelujem...",
			"sLengthMenu": "Prikaži _MENU_ zapisov",
			"sZeroRecords": "Noben zapis ni bil najden",
			"sInfo": "Prikazanih od _START_ do _END_ od skupno _TOTAL_ zapisov",
			"sInfoEmpty": "Prikazanih od 0 do 0 od skupno 0 zapisov",
			"sInfoFiltered": "(filtrirano po vseh _MAX_ zapisih)",
			"sInfoPostFix": "",
			"sSearch": "Išči po vseh stolpcih:",
			"buttons": {
				"colvis": "Vidnost stolpcev"
			},
			"sUrl": "",
			"oPaginate": {
				"sFirst": "Prva",
				"sPrevious": "Nazaj",
				"sNext": "Naprej",
				"sLast": "Zadnja"
			}
		}
	});
	
	
	// Implementacija iskanja v nogi tabele: element <input type="text">
	$(".targetTable tfoot th input[type=text]").on('keyup change', function() {
		
		table
			.column($(this).parent().index() + ':visible')
			.search(this.value)
			.draw();
			
	});
	
	// Implementacija iskanja v nogi tabele: element <select class="filterSelect">
	$(".targetTable tfoot th .filterSelect").on('change', function() {
		
		var val = $.fn.dataTable.util.escapeRegex(
			$(this).val()
		);
		
		table
		.column($(this).parent().index() + ':visible')
			.search(val ? '^' + val + '$' : '', true, false)
			.draw();
	});
	
	// Trigger za filtriranje tipa Date Range
	$('.rangeMinYear, .rangeMinMonth, .rangeMinDay, .rangeMaxYear, .rangeMaxMonth, .rangeMaxDay').keyup(function(event) {
		
		var target = $(event.target);
		var box = target.closest('div.rangeFilterWrapper');
		
		columnID = $(box).attr('data-target');
		
		minYear = $(box).find('input.rangeMinYear').val();
		minMonth = $(box).find('input.rangeMinMonth').val();
		minDay = $(box).find('input.rangeMinDay').val();
		maxYear = $(box).find('input.rangeMaxYear').val();
		maxMonth = $(box).find('input.rangeMaxMonth').val();
		maxDay = $(box).find('input.rangeMaxDay').val();
		
		table.draw();
		
	});
	
	// Trigger za filtriranje tipa Integer Range
	$('.rangeMinValue, .rangeMaxValue').keyup(function(event) {
		
		var target = $(event.target);
		var box = target.closest('div.rangeFilterWrapper');
		
		columnID = $(box).attr('data-target');
		
		minValue = $(box).find('input.rangeMinValue').val();
		maxValue = $(box).find('input.rangeMaxValue').val();
		
		table.draw();
		
	});
	
	// Trigger za čiščenje filtrov tipa Range
	$('.clearRangeFilter').click(function(event) {
		
		var box = $('.accordion');
		
		minValue = maxValue = minYear = minMonth = minDay = maxYear = maxMonth = maxDay = 0;
		
		$(box).find('input.rangeMinValue').val('');
		$(box).find('input.rangeMaxValue').val('');
		
		$(box).find('input.rangeMinYear').val('');
		$(box).find('input.rangeMinMonth').val('');
		$(box).find('input.rangeMinDay').val('');
		$(box).find('input.rangeMaxYear').val('');
		$(box).find('input.rangeMaxMonth').val('');
		$(box).find('input.rangeMaxDay').val('');
		
		table.draw();
		
	});
	
	// Trigger za čiščenje filtrov tipa Range vezan na klik na Accordion Title
	$('.accordion-title').click(function(event) {
		
		var box = $('.accordion');
		
		minValue = maxValue = minYear = minMonth = minDay = maxYear = maxMonth = maxDay = 0;
		
		$(box).find('input.rangeMinValue').val('');
		$(box).find('input.rangeMaxValue').val('');
		
		$(box).find('input.rangeMinYear').val('');
		$(box).find('input.rangeMinMonth').val('');
		$(box).find('input.rangeMinDay').val('');
		$(box).find('input.rangeMaxYear').val('');
		$(box).find('input.rangeMaxMonth').val('');
		$(box).find('input.rangeMaxDay').val('');
		
		table.draw();
		
	});
	
});
