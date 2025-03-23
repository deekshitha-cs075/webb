<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Procedure Form - Export</title>
    <script src="resources/js/xlsx.full.min.js"></script>
    <script src="resources/js/jspdf.umd.min.js"></script>
    <script src="resources/js/jspdf.plugin.autotable.min.js"></script> 
</head>
<body>

    <div class="container">
        <h2>Procedure Form</h2>

        <div class="form-group">
            <label>Title:</label>
            <input type="text" id="title">
        </div>

        <div class="form-group">
            <label>Applicability / Assumption:</label>
            <textarea id="applicability"></textarea>
        </div>

        <div class="form-group">
            <label>Prerequisites / Caution:</label>
            <textarea id="prerequisites"></textarea>
        </div>

        <h4>Procedure</h4>
        <table id="procedureTable" border="1">
            <thead>
                <tr>
                    <th>Description</th>
                    <th>Command Code</th>
                    <th>Indicators/Lamps</th>
                    <th>Data Value</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><input type="text"></td>
                    <td><input type="text"></td>
                    <td><input type="text"></td>
                    <td><input type="text"></td>
                </tr>
            </tbody>
        </table>

        <button id="generateExcel">Generate & Open Excel</button>
        <button id="generatePDF">Generate & Open PDF</button>
    </div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        console.log("Checking Libraries...");

        if (typeof XLSX !== "undefined") {
            console.log("? SheetJS loaded successfully.");
        } else {
            console.error("? SheetJS failed to load! Check file path.");
        }

        if (typeof window.jspdf !== "undefined") {
            console.log("? jsPDF loaded successfully.");
        } else {
            console.error("? jsPDF failed to load! Check file path.");
        }

        document.getElementById("generateExcel").addEventListener("click", generateExcel);
        document.getElementById("generatePDF").addEventListener("click", generatePDF);
    });

    function generateExcel() {
        let wb = XLSX.utils.book_new();
        let ws_data = [];

        // Get form data
        let title = document.getElementById("title").value;
        let applicability = document.getElementById("applicability").value;
        let prerequisites = document.getElementById("prerequisites").value;

        // Add form data to sheet
        ws_data.push(["Title", title]);
        ws_data.push(["Applicability / Assumption", applicability]);
        ws_data.push(["Prerequisites / Caution", prerequisites]);
        ws_data.push([]);

        // Get table data
        let table = document.querySelector("#procedureTable tbody");
        let rows = table.querySelectorAll("tr");

        // Add table headers
        ws_data.push(["Description", "Command Code", "Indicators/Lamps", "Data Value"]);

        // Add table row data
        rows.forEach(row => {
            let rowData = [];
            row.querySelectorAll("td input").forEach(input => {
                rowData.push(input.value);
            });
            ws_data.push(rowData);
        });

        // Create worksheet
        let ws = XLSX.utils.aoa_to_sheet(ws_data);
        XLSX.utils.book_append_sheet(wb, ws, "Procedure Form");

        // Generate Excel file
        let wbout = XLSX.write(wb, { bookType: "xlsx", type: "array" });
        let blob = new Blob([wbout], { type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" });
        let url = URL.createObjectURL(blob);

        // Create download link
        let a = document.createElement("a");
        a.href = url;
        a.download = "Procedure_Form.xlsx";
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);

        console.log("? Excel file generated successfully.");
    }

    function generatePDF() {
    const { jsPDF } = window.jspdf;
    let doc = new jsPDF();

    doc.setFontSize(16);
    doc.text("Procedure Form", 10, 10);

    let y = 20;
    doc.setFontSize(12);

    // Get form data
    doc.text("Title: " + document.getElementById("title").value, 10, y);
    y += 10;
    doc.text("Applicability / Assumption: " + document.getElementById("applicability").value, 10, y);
    y += 10;
    doc.text("Prerequisites / Caution: " + document.getElementById("prerequisites").value, 10, y);
    y += 20;

    // Table headers
    doc.autoTable({
        startY: y,
        head: [["Description", "Command Code", "Indicators/Lamps", "Data Value"]],
        body: getTableData(),
        theme: "grid",
        styles: { fontSize: 10, cellPadding: 3 },
        columnStyles: {
            0: { cellWidth: 50 },
            1: { cellWidth: 40 },
            2: { cellWidth: 50 },
            3: { cellWidth: 40 }
        }
    });

    // **Open in a New Tab**
    let blob = doc.output("blob");
    let url = URL.createObjectURL(blob);
    window.open(url);  // Opens PDF in new tab

    // **Trigger Download**
    doc.save("Procedure_Form.pdf");

    console.log("? PDF opened and downloaded successfully.");
}

// Function to extract table data
function getTableData() {
    let table = document.querySelector("#procedureTable tbody");
    let rows = table.querySelectorAll("tr");
    let data = [];

    rows.forEach(row => {
        let rowData = [];
        row.querySelectorAll("td input").forEach(input => {
            rowData.push(input.value);
        });
        data.push(rowData);
    });

    return data;
}

</script>

</body>
</html>
