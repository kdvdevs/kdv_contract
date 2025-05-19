window.addEventListener('message', function(event) {
    if (event.data.action === 'openContract') {
        document.getElementById('model').textContent = event.data.data.model;
        document.getElementById('plate').textContent = event.data.data.plate;
        document.getElementById('price').value = '';
        document.getElementById('buyerId').value = '';
        document.getElementById('contract').style.display = 'block';

        document.getElementById('price').setAttribute('min', event.data.data.priceMin);
        document.getElementById('price').setAttribute('max', event.data.data.priceMax);

        if (typeof event.data.data.useTransferCount !== 'undefined' && !event.data.data.useTransferCount) {
            document.getElementById('transferCountGroup').style.display = 'none';
        } else {
            document.getElementById('transferCountGroup').style.display = '';
            document.getElementById('transferCount').innerText = event.data.data.transferCount;
        }
    }
    if (event.data.action === 'closeContract') {
        document.getElementById('contract').style.display = 'none';
    }
    if (event.data.action === 'openBuyContract') {
        document.getElementById('contract').style.display = 'none';
        showBuyContract(event.data.data);
        document.getElementById('model').innerText = event.data.data.model;
        document.getElementById('plate').innerText = event.data.data.plate;
    }
});

document.getElementById('contractForm').addEventListener('submit', function(e) {
    e.preventDefault();
    const price = document.getElementById('price').value;
    const buyerId = document.getElementById('buyerId').value;
    const model = document.getElementById('model').textContent;
    const plate = document.getElementById('plate').textContent;
    fetch(`https://${GetParentResourceName()}/submitContract`, {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ price, buyerId, model, plate })
    });
    document.getElementById('contract').style.display = 'none';
});

document.getElementById('cancelBtn').addEventListener('click', function() {
    fetch(`https://${GetParentResourceName()}/closeContract`, { method: 'POST' });
    document.getElementById('contract').style.display = 'none';
});

function showBuyContract(data) {
    let buyDiv = document.getElementById('buyContract');
    if (!buyDiv) {
        buyDiv = document.createElement('div');
        buyDiv.id = 'buyContract';
        buyDiv.className = 'contract-container';
        buyDiv.innerHTML = `
            <h2>VEHICLE PURCHASE CONTRACT</h2>
            <form id="buyContractForm">
                <div class="form-group">
                    <label><i class="fa fa-car"></i> Model:</label>
                    <span class="info" id="buyModel"></span>
                </div>
                <div class="form-group">
                    <label><i class="fa fa-id-card"></i> Plate:</label>
                    <span class="info" id="buyPlate"></span>
                </div>
                <div class="form-group">
                    <label><i class="fa fa-dollar-sign"></i> Price:</label>
                    <span class="info" id="buyPrice" style="color:#1aff8c;"></span>
                </div>
                <div class="form-group">
                    <label><i class="fa fa-user"></i> Seller:</label>
                    <span class="info" id="buySeller"></span>
                </div>
                <div class="button-group">
                    <button type="submit" class="btn confirm">Confirm Purchase <i class="fa fa-check-circle"></i></button>
                    <button type="button" class="btn cancel" id="declineBuyBtn">Cancel <i class="fa fa-times-circle"></i></button>
                </div>
            </form>
        `;
        document.body.appendChild(buyDiv);

        document.getElementById('buyContractForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const price = document.getElementById('buyPrice').textContent.replace(/\D/g, '');
            const sellerId = data.sellerId;
            const buyerId = data.buyerId;
            const plate = document.getElementById('buyPlate').textContent;
            const model = document.getElementById('buyModel').textContent;

            fetch(`https://${GetParentResourceName()}/acceptBuyContract`, {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({ price, sellerId, buyerId, plate, model })
            });
            buyDiv.style.display = 'none';
        });

        document.getElementById('declineBuyBtn').addEventListener('click', function() {
            fetch(`https://${GetParentResourceName()}/declineBuyContract`, { method: 'POST' });
            buyDiv.style.display = 'none';
        });
    }
    document.getElementById('buyModel').textContent = data.model;
    document.getElementById('buyPlate').textContent = data.plate;
    document.getElementById('buyPrice').textContent = `$${data.price}`;
    document.getElementById('buySeller').textContent = `[${data.sellerId}] ${data.sellerName || ''}`;
    buyDiv.style.display = 'block';
}