// Baladi Hypermarket - Core JavaScript & Cart Management

// 1. Mock Product Dataset (structured to scale up to 3000 products easily)
const PRODUCTS = [
  // Let's Groove Audio Section Products
  {
    id: "buds-wireless-5-anc",
    name: "realme Buds Wireless 5 ANC",
    price: 1399.00,
    unit: "pc",
    category: "audio",
    image: "https://image01.realme.net/general/20250109/1736415319795d54ca63564df4a429066610426dbb975.png.webp?width=1440&height=1440&size=376999",
    tag: "Groove"
  },
  {
    id: "buds-air7",
    name: "realme Buds Air7",
    price: 2699.00,
    unit: "pc",
    category: "audio",
    image: "https://image01.realme.net/general/20250317/17422067439182f5867123e114ce09d2ef0306d1a8f9b.png.webp?width=1440&height=1440&size=1025011",
    tag: "Groove"
  },
  {
    id: "buds-air7-pro",
    name: "realme Buds Air7 Pro",
    price: 4499.00,
    unit: "pc",
    category: "audio",
    image: "https://image01.realme.net/general/20250519/1747633988406ef120377e0d14fc68f95246e96625de1.png.webp?width=1440&height=1440&size=813046",
    tag: "Groove"
  },
  {
    id: "techlife-studio-h1",
    name: "realme Techlife Studio H1",
    price: 3999.00,
    unit: "pc",
    category: "audio",
    image: "https://image01.realme.net/general/20241014/17288795936668c68fced6fb04cdb9365c8915f7fbd77.png.webp?width=1440&height=1440&size=282698",
    tag: "Groove"
  },
  // Groceries & Fresh Food
];

// Helper to render product image (either URL or Emoji)
function getProductImageHTML(imageStr, name, extraStyle = '') {
  const fallback = 'https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=300&q=80';
  if (imageStr && (imageStr.startsWith('http://') || imageStr.startsWith('https://'))) {
    if (imageStr.includes('placeholder.com')) {
      return `<img src="${fallback}" alt="${name}" referrerpolicy="no-referrer" style="width: 100%; height: 100%; object-fit: cover; max-height: 100%; opacity: 0.55; ${extraStyle}">`;
    }
    return `<img src="${imageStr}" alt="${name}" referrerpolicy="no-referrer" onerror="this.onerror=null;this.src='${fallback}';this.style.opacity='0.55';" style="width: 100%; height: 100%; object-fit: contain; max-height: 100%; ${extraStyle}">`;
  }
  return `<img src="${fallback}" alt="${name}" referrerpolicy="no-referrer" style="width: 100%; height: 100%; object-fit: cover; max-height: 100%; opacity: 0.55; ${extraStyle}">`;
}

// 2. State Variable
let cart = [];

// 3. Load & Save Operations
function loadCart() {
  const savedCart = localStorage.getItem('baladi_cart');
  if (savedCart) {
    try {
      cart = JSON.parse(savedCart);
    } catch (e) {
      cart = [];
    }
  }
}

function saveCart() {
  localStorage.setItem('baladi_cart', JSON.stringify(cart));
  updateCartCounters();
}

// 4. Cart Operations
function addToCart(productId) {
  const product = PRODUCTS.find(p => p.id === productId);
  if (!product) return;

  const existingItem = cart.find(item => item.id === productId);
  if (existingItem) {
    existingItem.quantity += 1;
  } else {
    cart.push({
      id: product.id,
      name: product.name,
      price: product.price,
      unit: product.unit,
      category: product.category,
      image: product.image,
      quantity: 1
    });
  }

  saveCart();
  renderCart();
  showToast(`${product.name} added to cart!`);
}

function updateQuantity(productId, action) {
  const item = cart.find(item => item.id === productId);
  if (!item) return;

  if (action === 'increase') {
    item.quantity += 1;
  } else if (action === 'decrease') {
    item.quantity -= 1;
    if (item.quantity <= 0) {
      removeFromCart(productId);
      return;
    }
  }

  saveCart();
  renderCart();
}

function removeFromCart(productId) {
  const productIndex = cart.findIndex(item => item.id === productId);
  if (productIndex > -1) {
    const productName = cart[productIndex].name;
    cart.splice(productIndex, 1);
    saveCart();
    renderCart();
    showToast(`${productName} removed from cart.`);
  }
}

function clearCart() {
  cart = [];
  saveCart();
  renderCart();
}

function getCartTotal() {
  return cart.reduce((total, item) => total + (item.price * item.quantity), 0);
}

function getCartCount() {
  return cart.reduce((count, item) => count + item.quantity, 0);
}

// 5. User Interface Interactions & Rendering
function updateCartCounters() {
  const count = getCartCount();
  const badges = document.querySelectorAll('.cart-badge');
  badges.forEach(badge => {
    badge.textContent = count;
    badge.style.display = count > 0 ? 'flex' : 'none';
  });
}

function renderCart() {
  const cartContainer = document.querySelector('.cart-items-container');
  if (!cartContainer) return;

  if (cart.length === 0) {
    cartContainer.innerHTML = `
      <div class="cart-empty-message">
        <svg stroke="currentColor" fill="none" stroke-width="2" viewBox="0 0 24 24" height="1em" width="1em" xmlns="http://www.w3.org/2000/svg">
          <circle cx="9" cy="21" r="1"></circle>
          <circle cx="20" cy="21" r="1"></circle>
          <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path>
        </svg>
        <p>Your cart is empty.</p>
        <p style="font-size: 0.85rem;">Browse categories to add delicious products!</p>
      </div>
    `;
    
    const subtotalEl = document.querySelector('.subtotal-value');
    const vatEl = document.querySelector('.vat-value');
    const totalEl = document.querySelector('.total-value');
    const checkoutBtn = document.querySelector('.checkout-btn');

    if (subtotalEl) subtotalEl.textContent = 'AED 0.00';
    if (vatEl) vatEl.textContent = 'AED 0.00';
    if (totalEl) totalEl.textContent = 'AED 0.00';
    if (checkoutBtn) checkoutBtn.disabled = true;
    return;
  }

  cartContainer.innerHTML = cart.map(item => `
    <div class="cart-item">
      <div style="font-size: 2.8rem; background: var(--border); width: 60px; height: 60px; display: flex; align-items: center; justify-content: center; border-radius: var(--radius-sm); overflow: hidden;">
        ${getProductImageHTML(item.image, item.name, 'border-radius: var(--radius-sm);')}
      </div>
      <div class="cart-item-details">
        <div class="cart-item-title">${item.name}</div>
        <div class="cart-item-price">AED ${item.price.toFixed(2)} <span style="font-size: 0.75rem; color: var(--text-light);">/ ${item.unit}</span></div>
      </div>
      <div class="cart-item-actions">
        <button class="quantity-btn" onclick="updateQuantity('${item.id}', 'decrease')">-</button>
        <span class="cart-item-qty">${item.quantity}</span>
        <button class="quantity-btn" onclick="updateQuantity('${item.id}', 'increase')">+</button>
        <button class="remove-item-btn" onclick="removeFromCart('${item.id}')">
          <svg stroke="currentColor" fill="none" stroke-width="2" viewBox="0 0 24 24" height="1em" width="1em" xmlns="http://www.w3.org/2000/svg">
            <polyline points="3 6 5 6 21 6"></polyline>
            <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
            <line x1="10" y1="11" x2="10" y2="17"></line>
            <line x1="14" y1="11" x2="14" y2="17"></line>
          </svg>
        </button>
      </div>
    </div>
  `).join('');

  const subtotal = getCartTotal();
  const vat = subtotal * 0.05;
  const total = subtotal + vat;

  const subtotalEl = document.querySelector('.subtotal-value');
  const vatEl = document.querySelector('.vat-value');
  const totalEl = document.querySelector('.total-value');
  const checkoutBtn = document.querySelector('.checkout-btn');

  if (subtotalEl) subtotalEl.textContent = `AED ${subtotal.toFixed(2)}`;
  if (vatEl) vatEl.textContent = `AED ${vat.toFixed(2)}`;
  if (totalEl) totalEl.textContent = `AED ${total.toFixed(2)}`;
  if (checkoutBtn) checkoutBtn.disabled = false;

  // Render dedicated cart page if the renderer exists
  if (typeof window.renderCartPage === 'function') {
    window.renderCartPage();
  }
}

// 6. Generate Products Grid for Page
function renderProductGrid(filterCategory = 'all', searchQuery = '', filterSubcategory = 'all') {
  const grid = document.querySelector('.products-grid');
  if (!grid) return;

  let filtered = PRODUCTS;

  // Apply category filtering
  if (filterCategory !== 'all') {
    filtered = PRODUCTS.filter(p => p.category === filterCategory);
  }

  // Apply subcategory filtering (supports nested child matches)
  if (filterSubcategory !== 'all') {
    filtered = filtered.filter(p => {
      if (!p.subcategory) return false;
      return p.subcategory === filterSubcategory || p.subcategory.startsWith(filterSubcategory + ' > ');
    });
  }

  // Apply search query filtering
  if (searchQuery.trim() !== '') {
    const q = searchQuery.toLowerCase().trim();
    filtered = filtered.filter(p => p.name.toLowerCase().includes(q) || p.category.replace('-', ' ').toLowerCase().includes(q));
  }

  // Set the product count badge if it exists
  const countBadge = document.getElementById('product-count') || document.querySelector('.product-count-badge');
  if (countBadge) {
    countBadge.textContent = `${filtered.length} Items`;
  }

  if (filtered.length === 0) {
    grid.innerHTML = `
      <div style="grid-column: 1 / -1; text-align: center; padding: 4rem 2rem; color: var(--text-light);">
        <p style="font-size: 1.5rem; font-weight: 700; margin-bottom: 0.5rem;">No products found</p>
        <p>Try searching for another product name or checking a different category.</p>
      </div>
    `;
    return;
  }

  grid.innerHTML = filtered.map(product => {
    // Deal vs regular price display logic
    const priceDisplay = product.isDeal 
      ? `<span style="text-decoration: line-through; color: var(--text-light); font-size: 0.9rem; margin-right: 0.5rem; font-weight: 400;">AED ${product.originalPrice.toFixed(2)}</span>AED ${product.price.toFixed(2)}`
      : `AED ${product.price.toFixed(2)}`;

    return `
      <div class="product-card" data-id="${product.id}">
        <span class="product-tag">${product.tag}</span>
        <div class="product-image-container" style="overflow: hidden;">
          <div style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; font-size: 6.5rem; user-select: none;">
            ${getProductImageHTML(product.image, product.name)}
          </div>
        </div>
        <div class="product-info">
          <span class="product-category">${(product.subcategory || product.category).replace(/^[^>]+>\s*/, '').replace(/-/g, ' ')}</span>
          <h3 class="product-title">${product.name}</h3>
          <div class="product-price-row">
            <div class="product-price">
              ${priceDisplay}
              <span style="font-size: 0.85rem; color: var(--text-light); font-weight: 500;">/ ${product.unit}</span>
            </div>
            <button class="add-to-cart-btn" onclick="addToCart('${product.id}')">
              <svg stroke="currentColor" fill="none" stroke-width="2.5" viewBox="0 0 24 24" height="1.2em" width="1.2em" xmlns="http://www.w3.org/2000/svg">
                <line x1="12" y1="5" x2="12" y2="19"></line>
                <line x1="5" y1="12" x2="19" y2="12"></line>
              </svg>
            </button>
          </div>
        </div>
      </div>
    `;
  }).join('');
}

// 6b. Live Deals Grid Renderer
function renderDealsGrid() {
  const grid = document.querySelector('.deals-grid');
  if (!grid) return;

  const deals = PRODUCTS.filter(p => p.isDeal);

  grid.innerHTML = deals.map(product => `
    <div class="product-card deal-card" data-id="${product.id}">
      <span class="product-tag" style="background: #ef4444; color: white; font-weight: bold;">${product.tag}</span>
      <div class="product-image-container" style="overflow: hidden;">
        <div style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; font-size: 6.5rem; user-select: none;">
          ${getProductImageHTML(product.image, product.name)}
        </div>
      </div>
      <div class="product-info">
        <span class="product-category" style="color: #ef4444; font-weight: 800;">ðŸ”¥ Flash Deal</span>
        <h3 class="product-title">${product.name}</h3>
        <div class="product-price-row">
          <div class="product-price">
            <span style="text-decoration: line-through; color: var(--text-light); font-size: 0.9rem; margin-right: 0.5rem; font-weight: 400;">AED ${product.originalPrice.toFixed(2)}</span>
            AED ${product.price.toFixed(2)}
            <span style="font-size: 0.85rem; color: var(--text-light); font-weight: 500;">/ ${product.unit}</span>
          </div>
          <button class="add-to-cart-btn" onclick="addToCart('${product.id}')" style="background: #ef4444;">
            <svg stroke="currentColor" fill="none" stroke-width="2.5" viewBox="0 0 24 24" height="1.2em" width="1.2em" xmlns="http://www.w3.org/2000/svg">
              <line x1="12" y1="5" x2="12" y2="19"></line>
              <line x1="5" y1="12" x2="19" y2="12"></line>
            </svg>
          </button>
        </div>
      </div>
    </div>
  `).join('');
}

// 6c. Subcategory Filter Pills Renderer (with two-level nested support for Fresh Food)
let activeParent = 'all';
let activeChild = 'all';

function renderSubcategoryPills(category) {
  const container = document.querySelector('.subcategory-pills');
  if (!container) return;

  if (category !== 'fresh-food') {
    // For single-level categories (Fruits & Veg, Food Cupboard, Beverages)
    const categoryProducts = PRODUCTS.filter(p => p.category === category);
    const subcategories = [...new Set(categoryProducts.map(p => p.subcategory))].filter(Boolean);

    if (subcategories.length === 0) {
      container.style.display = 'none';
      return;
    }

    const formatName = (str) => {
      return str.split('-').map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' & ');
    };

    container.innerHTML = `
      <button class="filter-pill active" onclick="filterBySubcategory('all', this)">All Products</button>
      ` + subcategories.map(sub => `
        <button class="filter-pill" onclick="filterBySubcategory('${sub}', this)">${formatName(sub)}</button>
      `).join('');
    return;
  }

  // Nested double-row layout for fresh-food!
  const parents = [
    { id: 'all', label: 'All Fresh Food' },
    { id: 'Dairy & Eggs', label: 'Dairy & Eggs' },
    { id: 'Ready To Cook', label: 'Ready To Cook' },
    { id: 'Meat & Poultry', label: 'Meat & Poultry' },
    { id: 'Fish & Seafood', label: 'Fish & Seafood' },
    { id: 'Food To Go', label: 'Food To Go' },
    { id: 'Chilled Food Counter', label: 'Chilled Food Counter' }
  ];

  const childrenMap = {
    'Dairy & Eggs': ['Cheese & Labneh', 'Milk & Laban', 'Eggs', 'Yoghurt', 'Butter & Margarine', 'Cream', 'Chilled Desserts'],
    'Meat & Poultry': ['Chicken', 'Beef', 'Lamb', 'Veal', 'Offals'],
    'Fish & Seafood': ['Fish', 'Seafood'],
    'Food To Go': ['Salads & Soup', 'Ready Meals', 'Appetizers & Bites', 'Sushi & Sashimi'],
    'Chilled Food Counter': ['Cold Cuts & Meat Snacks', 'Olives & Antipasti', 'Seafood & Caviar', 'Dips, Spreads & Pï¿½tï¿½', 'Kimchi', 'Dressing']
  };

  const renderPills = () => {
    // Render parent row HTML
    const parentHTML = `<div class="parent-pills-row" style="display: flex; flex-wrap: wrap; gap: 0.5rem; justify-content: center; width: 100%;">` +
      parents.map(p => {
        const activeClass = activeParent === p.id ? 'active' : '';
        return `<button class="filter-pill ${activeClass}" onclick="selectParentSubcategory('${p.id}')">${p.label}</button>`;
      }).join('') + `</div>`;

    // Render child row HTML if applicable
    let childHTML = '';
    const children = childrenMap[activeParent];
    if (children && children.length > 0) {
      childHTML = `<div class="child-pills-row" style="display: flex; flex-wrap: wrap; gap: 0.4rem; justify-content: center; margin-top: 0.75rem; width: 100%; padding: 0.5rem; background: rgba(11, 49, 132, 0.03); border-radius: var(--radius-md); border: 1px dashed rgba(11, 49, 132, 0.1);">` +
        `<button class="filter-pill ${activeChild === 'all' ? 'active' : ''}" style="font-size: 0.8rem; padding: 0.4rem 0.8rem;" onclick="selectChildSubcategory('all')">All ${activeParent}</button>` +
        children.map(c => {
          const activeClass = activeChild === c ? 'active' : '';
          return `<button class="filter-pill ${activeClass}" style="font-size: 0.8rem; padding: 0.4rem 0.8rem;" onclick="selectChildSubcategory('${c}')">${c}</button>`;
        }).join('') + `</div>`;
    }

    container.innerHTML = `<div style="display: flex; flex-direction: column; align-items: center; width: 100%;">${parentHTML}${childHTML}</div>`;
  };

  // Assign selectors globally for onclick attributes
  window.selectParentSubcategory = (parentId) => {
    activeParent = parentId;
    activeChild = 'all';
    renderPills();
    
    const pageCategory = document.body.getAttribute('data-category') || 'fresh-food';
    renderProductGrid(pageCategory, '', activeParent);
  };

  window.selectChildSubcategory = (childId) => {
    activeChild = childId;
    renderPills();
    
    const pageCategory = document.body.getAttribute('data-category') || 'fresh-food';
    if (activeChild === 'all') {
      renderProductGrid(pageCategory, '', activeParent);
    } else {
      renderProductGrid(pageCategory, '', `${activeParent} > ${activeChild}`);
    }
  };

  renderPills();
}

function filterBySubcategory(subcategory, btnElement) {
  const container = document.querySelector('.subcategory-pills');
  if (container) {
    const pills = container.querySelectorAll('.filter-pill');
    pills.forEach(pill => pill.classList.remove('active'));
  }
  if (btnElement) {
    btnElement.classList.add('active');
  }

  const pageCategory = document.body.getAttribute('data-category') || 'all';
  renderProductGrid(pageCategory, '', subcategory);
}

// 6d. Flash Deals Countdown Timer
function startFlashDealsTimer() {
  const timerEl = document.getElementById('deal-timer');
  if (!timerEl) return;

  let secondsLeft = localStorage.getItem('baladi_deal_seconds');
  if (!secondsLeft) {
    secondsLeft = 2 * 3600 + 45 * 60 + 12; 
  } else {
    secondsLeft = parseInt(secondsLeft, 10);
  }

  const updateTimerDisplay = () => {
    if (secondsLeft <= 0) {
      secondsLeft = 3 * 3600; 
    }
    
    const h = Math.floor(secondsLeft / 3600);
    const m = Math.floor((secondsLeft % 3600) / 60);
    const s = secondsLeft % 60;

    const pad = (val) => String(val).padStart(2, '0');
    timerEl.innerHTML = `Ends in: <strong style="color: var(--primary); font-family: var(--font-heading); font-size: 1.1rem; margin-left: 0.25rem;">${pad(h)}h ${pad(m)}m ${pad(s)}s</strong>`;
    
    secondsLeft--;
    localStorage.setItem('baladi_deal_seconds', secondsLeft);
  };

  updateTimerDisplay();
  setInterval(updateTimerDisplay, 1000);
}

// 7. Toast Notification Handler
function showToast(message) {
  let toast = document.querySelector('.toast');
  if (!toast) {
    toast = document.createElement('div');
    toast.className = 'toast toast-success';
    document.body.appendChild(toast);
  }
  toast.innerHTML = `
    <svg stroke="currentColor" fill="none" stroke-width="2.5" viewBox="0 0 24 24" height="1.2em" width="1.2em" xmlns="http://www.w3.org/2000/svg" style="color: var(--primary);">
      <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
      <polyline points="22 4 12 14.01 9 11.01"></polyline>
    </svg>
    <span>${message}</span>
  `;
  toast.classList.add('show');
  setTimeout(() => {
    toast.classList.remove('show');
  }, 2500);
}

// 8. PDF Generation using jsPDF (Loaded from CDN)
function generateInvoicePDF(customerDetails) {
  // Safe resolver for jsPDF library (checking both UMD layouts)
  const jsPDFClass = (window.jspdf && window.jspdf.jsPDF) || window.jsPDF;
  if (!jsPDFClass) {
    console.error("jsPDF library is not loaded in window namespace.");
    alert("Invoice PDF Error:\n\nThe jsPDF library failed to load. Please make sure you are connected to the internet and reload the page.");
    return null;
  }

  let doc;
  try {
    doc = new jsPDFClass({
      orientation: 'portrait',
      unit: 'mm',
      format: 'a4'
    });
  } catch (err) {
    console.error("Failed to construct jsPDF instance:", err);
    alert("Invoice PDF Error:\n\nFailed to initialize the PDF writer. " + err.message);
    return null;
  }

  const invoiceNum = 'BAL-' + Math.floor(100000 + Math.random() * 900000);
  const orderDate = new Date().toLocaleString();

  // Colors
  const darkBlue = [11, 49, 132];
  const gold = [243, 180, 22];
  const charcoal = [33, 37, 41];
  const lightGray = [248, 249, 250];

  // Header Block Design
  doc.setFillColor(darkBlue[0], darkBlue[1], darkBlue[2]);
  doc.rect(0, 0, 210, 45, 'F');

  // Gold accent bar
  doc.setFillColor(gold[0], gold[1], gold[2]);
  doc.rect(0, 45, 210, 3, 'F');

  // Header Typography
  doc.setTextColor(255, 255, 255);
  doc.setFont('Helvetica', 'bold');
  doc.setFontSize(26);
  doc.text('BALADI HYPERMARKET', 15, 20);
  doc.setFontSize(10);
  doc.setFont('Helvetica', 'normal');
  doc.text('Premium Products, Best Value', 15, 26);
  doc.text('Dubai, UAE | support@baladihypermarket.com', 15, 31);
  doc.text('Tel: 0526278571', 15, 36);

  // Invoice Title Block
  doc.setFont('Helvetica', 'bold');
  doc.setFontSize(22);
  doc.text('INVOICE / LIST', 135, 20);
  doc.setFontSize(10);
  doc.setFont('Helvetica', 'normal');
  doc.text(`Invoice ID: ${invoiceNum}`, 135, 27);
  doc.text(`Date: ${orderDate.split(',')[0]}`, 135, 33);
  doc.text(`Time: ${orderDate.split(',')[1] || ''}`, 135, 39);

  // Customer Details Block
  doc.setTextColor(charcoal[0], charcoal[1], charcoal[2]);
  doc.setFont('Helvetica', 'bold');
  doc.setFontSize(12);
  doc.text('CUSTOMER DETAILS', 15, 60);
  doc.setDrawColor(220, 220, 220);
  doc.line(15, 62, 195, 62);

  doc.setFont('Helvetica', 'normal');
  doc.setFontSize(10);
  doc.text(`Customer Name: ${customerDetails.name}`, 15, 69);
  doc.text(`Contact Phone: ${customerDetails.phone}`, 15, 75);
  doc.text(`Order Type: ${customerDetails.delivery.toUpperCase()}`, 15, 81);

  // Items Table Header
  const tableStartY = 92;
  doc.setFillColor(darkBlue[0], darkBlue[1], darkBlue[2]);
  doc.rect(15, tableStartY, 180, 8, 'F');

  doc.setTextColor(255, 255, 255);
  doc.setFont('Helvetica', 'bold');
  doc.setFontSize(9);
  doc.text('Product Description', 18, tableStartY + 5.5);
  doc.text('Qty', 115, tableStartY + 5.5);
  doc.text('Unit Price', 135, tableStartY + 5.5);
  doc.text('Total (AED)', 168, tableStartY + 5.5);

  // Populate Table Items
  let currentY = tableStartY + 8;
  doc.setTextColor(charcoal[0], charcoal[1], charcoal[2]);
  doc.setFont('Helvetica', 'normal');

  cart.forEach((item, index) => {
    // Alternating row background colors
    if (index % 2 === 1) {
      doc.setFillColor(lightGray[0], lightGray[1], lightGray[2]);
      doc.rect(15, currentY, 180, 8, 'F');
    }
    
    // Grid border lines
    doc.setDrawColor(240, 240, 240);
    doc.line(15, currentY + 8, 195, currentY + 8);

    doc.text(`${item.name} (${item.unit})`, 18, currentY + 5.5);
    doc.text(`${item.quantity}`, 117, currentY + 5.5);
    doc.text(`AED ${item.price.toFixed(2)}`, 135, currentY + 5.5);
    
    const rowTotal = item.price * item.quantity;
    doc.text(`AED ${rowTotal.toFixed(2)}`, 168, currentY + 5.5);

    currentY += 8;
  });

  // Calculate pricing details
  const subtotal = getCartTotal();
  const isCouponApplied = localStorage.getItem('baladi_coupon') === 'SKIDS10';
  const discount = isCouponApplied ? subtotal * 0.10 : 0;
  const isDelivery = customerDetails.delivery === 'delivery';
  const deliveryFee = (isDelivery && subtotal < 150) ? 10.00 : 0.00;
  const vat = (subtotal - discount) * 0.05;
  const total = (subtotal - discount) + deliveryFee + vat;

  // Right-aligned Price Summary
  currentY += 8;
  doc.setFont('Helvetica', 'normal');
  doc.text('Subtotal:', 135, currentY);
  doc.text(`AED ${subtotal.toFixed(2)}`, 168, currentY);

  if (isCouponApplied) {
    currentY += 6;
    doc.text('Discount (10%):', 135, currentY);
    doc.text(`-AED ${discount.toFixed(2)}`, 168, currentY);
  }

  currentY += 6;
  doc.text('Delivery:', 135, currentY);
  doc.text(deliveryFee === 0 ? 'FREE' : `AED ${deliveryFee.toFixed(2)}`, 168, currentY);

  currentY += 6;
  doc.text('VAT (5%):', 135, currentY);
  doc.text(`AED ${vat.toFixed(2)}`, 168, currentY);

  currentY += 8;
  doc.setFillColor(lightGray[0], lightGray[1], lightGray[2]);
  doc.rect(130, currentY - 5, 65, 8, 'F');
  doc.setFont('Helvetica', 'bold');
  doc.text('Grand Total:', 135, currentY + 0.5);
  doc.text(`AED ${total.toFixed(2)}`, 168, currentY + 0.5);

  // Cashier Barcode/QR Code Generator simulation (Vector Drawing)
  // Let's draw an authentic-looking barcode at the bottom
  const barcodeY = Math.max(currentY + 22, 175);
  doc.setFont('Helvetica', 'bold');
  doc.setFontSize(10);
  doc.text('CASHIER SCAN BARCODE', 15, barcodeY - 4);

  // Draw barcode lines vector style
  let barcodeX = 15;
  const barcodeWidthPattern = [
    1, 2, 1, 3, 1, 1, 2, 4, 1, 2, 3, 1, 2, 1, 1, 3, 2, 1, 4, 1, 1, 2, 1, 3, 1, 1, 2, 4, 1, 2, 3, 1, 2, 1, 1, 3, 2, 1
  ];
  
  doc.setFillColor(0, 0, 0);
  for (let i = 0; i < barcodeWidthPattern.length; i++) {
    const w = barcodeWidthPattern[i] * 0.8;
    if (i % 2 === 0) {
      doc.rect(barcodeX, barcodeY, w, 15, 'F');
    }
    barcodeX += w + 0.6;
  }
  
  // Barcode alphanumeric text below
  doc.setFont('Courier', 'normal');
  doc.setFontSize(8);
  doc.text(`*${invoiceNum}*`, 24, barcodeY + 19);

  // Store terms and conditions footer
  doc.setFont('Helvetica', 'italic');
  doc.setFontSize(8);
  doc.setTextColor(120, 120, 120);
  doc.text('Please present this PDF invoice to the cashier at checkout for immediate scanning and payment.', 15, barcodeY + 28);
  doc.text('Thank you for shopping with Baladi Hypermarket!', 15, barcodeY + 32);

  // Save the generated document
  doc.save(`Invoice_${invoiceNum}.pdf`);
  return { invoiceNum, total, date: orderDate };
}

// 9. WhatsApp Checkout Integration
function shareCartOnWhatsApp(customerName, customerPhone, deliveryMethod) {
  if (cart.length === 0) {
    showToast('Your cart is empty!');
    return;
  }

  // 1. Generate and automatically download the PDF invoice
  const invoiceData = generateInvoicePDF({
    name: customerName,
    phone: customerPhone,
    delivery: deliveryMethod
  });

  if (!invoiceData) {
    return; // Don't redirect if PDF failed to generate
  }

  // 2. Formulate the WhatsApp text message
  let message = `?? *BALADI HYPERMARKET ORDER* ??\n`;
  message += `------------------------------------\n`;
  message += `*Invoice ID:* ${invoiceData.invoiceNum}\n`;
  message += `*Date:* ${invoiceData.date.split(',')[0]}\n`;
  message += `*Customer:* ${customerName}\n`;
  message += `*Phone:* ${customerPhone}\n`;
  message += `*Option:* ${deliveryMethod === 'delivery' ? '?? Home Delivery' : '?? In-Store Pickup'}\n`;
  message += `------------------------------------\n\n`;
  message += `*ORDER ITEMS:* \n`;

  cart.forEach(item => {
    message += `ï¿½ ${item.name} x ${item.quantity} - AED ${(item.price * item.quantity).toFixed(2)}\n`;
  });

  const subtotal = getCartTotal();
  const isCouponApplied = localStorage.getItem('baladi_coupon') === 'SKIDS10';
  const discount = isCouponApplied ? subtotal * 0.10 : 0;
  const isDelivery = deliveryMethod === 'delivery';
  const deliveryFee = (isDelivery && subtotal < 150) ? 10.00 : 0.00;
  const vat = (subtotal - discount) * 0.05;
  const total = (subtotal - discount) + deliveryFee + vat;

  message += `\n------------------------------------\n`;
  message += `*Subtotal:* AED ${subtotal.toFixed(2)}\n`;
  if (isCouponApplied) {
    message += `*Coupon Discount (10%):* - AED ${discount.toFixed(2)}\n`;
  }
  message += `*Delivery:* ${deliveryFee === 0 ? 'FREE' : 'AED ' + deliveryFee.toFixed(2)}\n`;
  message += `*VAT (5%):* AED ${vat.toFixed(2)}\n`;
  message += `*GRAND TOTAL:* AED ${total.toFixed(2)}\n`;
  message += `------------------------------------\n\n`;
  message += `?? *I have downloaded and attached my invoice PDF (Invoice_${invoiceData.invoiceNum}.pdf) containing the barcodes for checkout.*`;

  // Encode the message
  const encodedMsg = encodeURIComponent(message);
  
  // Open WhatsApp Web/Mobile chat (using a default placeholder cashier phone number or dynamic)
  // Standard format is wa.me/phone?text=urlencoded
  // We can let the user input the cashier phone or use a standard dummy one +971500000000
  const cashierPhone = '971526278571'; // Default UAE Cashier Hot-line
  const whatsappUrl = `https://api.whatsapp.com/send?phone=${cashierPhone}&text=${encodedMsg}`;

  // Redirect to WhatsApp
  setTimeout(() => {
    window.open(whatsappUrl, '_blank');
  }, 1000);

  // Clear cart after checkout option
  setTimeout(() => {
    clearCart();
    // Close the drawer & modal
    closeCheckoutModal();
    closeCartDrawer();
  }, 2000);
}

// 10. Drawer and Modal Controls
function openCartDrawer(e) {
  if (window.innerWidth <= 768) {
    if (e && typeof e.preventDefault === 'function') e.preventDefault();
    window.location.href = 'cart.html';
    return;
  }
  const drawer = document.querySelector('.cart-drawer');
  const overlay = document.querySelector('.cart-overlay');
  if (drawer && overlay) {
    drawer.classList.add('open');
    overlay.classList.add('open');
  }
}

function closeCartDrawer() {
  const drawer = document.querySelector('.cart-drawer');
  const overlay = document.querySelector('.cart-overlay');
  if (drawer && overlay) {
    drawer.classList.remove('open');
    overlay.classList.remove('open');
  }
}

function openCheckoutModal() {
  const modal = document.querySelector('.checkout-modal-overlay');
  if (modal) {
    modal.classList.add('open');
  }
}

function closeCheckoutModal() {
  const modal = document.querySelector('.checkout-modal-overlay');
  if (modal) {
    modal.classList.remove('open');
  }
}

// 11. Initializer functions
function initCartUI() {
  loadCart();
  renderCart();
  updateCartCounters();

  // Setup Event Listeners
  const cartBtn = document.querySelector('.cart-trigger');
  if (cartBtn) {
    cartBtn.addEventListener('click', openCartDrawer);
  }

  const closeBtn = document.querySelector('.cart-close');
  if (closeBtn) {
    closeBtn.addEventListener('click', closeCartDrawer);
  }

  const overlay = document.querySelector('.cart-overlay');
  if (overlay) {
    overlay.addEventListener('click', closeCartDrawer);
  }

  const checkoutBtn = document.querySelector('.checkout-btn');
  if (checkoutBtn) {
    checkoutBtn.addEventListener('click', () => {
      // Close cart drawer first
      closeCartDrawer();
      // Open Checkout Modal
      openCheckoutModal();
    });
  }

  const modalClose = document.querySelector('.modal-close');
  if (modalClose) {
    modalClose.addEventListener('click', closeCheckoutModal);
  }

  // Handle Search Input in Header
  const searchInput = document.querySelector('.search-box input');
  if (searchInput) {
    searchInput.addEventListener('input', (e) => {
      const pageCategory = document.body.getAttribute('data-category') || 'all';
      renderProductGrid(pageCategory, e.target.value);
    });
  }

  // Handle Checkout Form Submission
  const checkoutForm = document.getElementById('checkout-form');
  if (checkoutForm) {
    checkoutForm.addEventListener('submit', (e) => {
      e.preventDefault();
      const customerName = document.getElementById('cust-name').value;
      const customerPhone = document.getElementById('cust-phone').value;
      const deliveryMethod = document.getElementById('cust-delivery').value;
      
      shareCartOnWhatsApp(customerName, customerPhone, deliveryMethod);
    });
  }
  // Handle Mobile Menu Drawer Toggle
  const burgerBtns = document.querySelectorAll('.hamburger-menu');
  const bottomCategoriesBtn = document.querySelector('.categories-trigger-btn');
  const mobileOverlay = document.querySelector('.mobile-nav-overlay');
  const mobileDrawer = document.querySelector('.mobile-nav-drawer');
  const drawerCloseBtn = document.querySelector('.drawer-close-btn');

  const openMobileMenu = () => {
    if (mobileDrawer) mobileDrawer.classList.add('open');
    if (mobileOverlay) mobileOverlay.classList.add('open');
  };

  const closeMobileMenu = () => {
    if (mobileDrawer) mobileDrawer.classList.remove('open');
    if (mobileOverlay) mobileOverlay.classList.remove('open');
  };

  burgerBtns.forEach(btn => btn.addEventListener('click', openMobileMenu));
  if (bottomCategoriesBtn) bottomCategoriesBtn.addEventListener('click', openMobileMenu);
  if (drawerCloseBtn) drawerCloseBtn.addEventListener('click', closeMobileMenu);
  if (mobileOverlay) mobileOverlay.addEventListener('click', closeMobileMenu);

  // Bottom Cart Button Opens Cart Drawer
  const bottomCartBtn = document.querySelector('.cart-trigger-btn');
  if (bottomCartBtn) {
    bottomCartBtn.addEventListener('click', openCartDrawer);
  }

  // Bottom Search Button focuses Search Input
  const bottomSearchBtn = document.querySelector('.search-trigger-btn');
  if (bottomSearchBtn) {
    bottomSearchBtn.addEventListener('click', () => {
      const searchBoxInput = document.querySelector('.search-box input');
      if (searchBoxInput) {
        searchBoxInput.focus();
        searchBoxInput.scrollIntoView({ behavior: 'smooth', block: 'center' });
      }
    });
  }
  // Auto-render products if we are on a category page
  const pageCategory = document.body.getAttribute('data-category') || 'all';
  if (pageCategory && pageCategory !== 'all') {
    renderProductGrid(pageCategory);
    renderSubcategoryPills(pageCategory);
  } else if (pageCategory === 'all') {
    renderProductGrid('all');
    renderDealsGrid();
    startFlashDealsTimer();
  }
}

// Execute when DOM is fully parsed
document.addEventListener('DOMContentLoaded', initCartUI);


